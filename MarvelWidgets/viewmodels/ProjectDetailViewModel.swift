//
//  ProjectDetailViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation
import SwiftUI
import EventKit

class ProjectDetailViewModel: ObservableObject {
    @Published var project: ProjectWrapper {
        didSet {    
            posterURL = project.attributes.posters?.first?.posterURL
        }
    }
    @Published var showBottomLoader = true
    @Published var posterURL: String?
    @Published var posterIndex: Int = 0 {
        didSet {
            withAnimation {
                posterURL = project.attributes.posters?[posterIndex].posterURL
            }
        }
    }
    @Published var showCalendarAppointment: Bool = false
    @Published var tableViewContent: [(Int, any View)] = []
    
    let store = EKEventStore()
    
    init(project: ProjectWrapper) {
        self.project = project
        self.posterURL = project.attributes.posters?.first?.posterURL
        
        getTableViewContent()
        
        Task {
            await refresh(id: project.id)
        }
    }
    
    func getTableViewContent() {
        var tableViewContent: [any View] = []
        if let saga = project.attributes.saga {
            tableViewContent.append(TableRowView(title: "Saga", value: saga.rawValue))
        }
        
        if let phase = project.attributes.phase {
            tableViewContent.append(TableRowView(title: "Phase", value: phase.rawValue))
        }
        
        if let postCreditScenes = project.attributes.postCreditScenes {
            tableViewContent.append(TableRowView(title: "Post Credit Scenes", value: String(postCreditScenes)))
        }
        
        if let boxOffice = project.attributes.boxOffice {
            tableViewContent.append(TableRowView(title: "Worldwide Box Office", value: boxOffice.toMoney()))
        }
        
        if let budget = project.attributes.productionBudget {
            tableViewContent.append(TableRowView(title: "Production Budget", value: budget.toMoney()))
        }
        
        if let awardsNominated = project.attributes.awardsNominated {
            tableViewContent.append(contentsOf: [
                TableRowView(title: "Awards Nominated", value: String(awardsNominated)),
                TableRowView(title: "Awards Won", value: String(project.attributes.awardsWon ?? 0))
            ])
        }
        
        self.tableViewContent = tableViewContent.enumerated().compactMap { ($0, $1) }
    }
    
    func refresh(id: Int, force: Bool = false) async {
        if let populatedProject = await ProjectService.getById(id, force: force) {
            await MainActor.run {
                withAnimation {
                    self.project = populatedProject
                }
            }
        }
        
        await MainActor.run {
            withAnimation {
                showBottomLoader = false
            }
        }
    }
    
    func swipeImage(direction: SwipeHVDirection) {
        if let posters = project.attributes.posters {
            if direction == .right {
                if posterIndex + 1 < posters.count {
                    posterIndex += 1
                } else {
                    posterIndex = 0
                }
            } else if direction == .left {
                if posterIndex - 1 >= 0 {
                    posterIndex -= 1
                } else {
                    posterIndex = posters.count - 1
                }
            }
        }
    }
    
    func createEventinTheCalendar() {
        guard let releaseDate = project.attributes.releaseDate?.toDate() else { return }
        
        store.requestAccess(to: .event) { (success, error) in
            if  error == nil {
                let event = EKEvent(eventStore: self.store)
                event.title = self.project.attributes.title
                event.calendar = self.store.defaultCalendarForNewEvents
                event.startDate = releaseDate
                event.endDate = releaseDate
                event.isAllDay = true
                
                event.addAlarm(EKAlarm(absoluteDate: Date(timeInterval: -3600, since: event.startDate)))
                
                do {
                    try self.store.save(event, span: .thisEvent)
                    
                    let interval = releaseDate.timeIntervalSinceReferenceDate
                    if let url = URL(string: "calshow:\(interval)") {
                        Task {
                            await MainActor.run {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    }
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }

            } else {
                //we have error in getting access to device calnedar
                print("error = \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    enum SwipeHVDirection: String {
        case left, right, up, down, none
    }

    func detectDirection(value: DragGesture.Value) -> SwipeHVDirection {
        if value.startLocation.x < value.location.x - 24 {
            return .left
        }
        if value.startLocation.x > value.location.x + 24 {
            return .right
        }
        if value.startLocation.y < value.location.y - 24 {
            return .down
        }
        if value.startLocation.y > value.location.y + 24 {
            return .up
        }
        return .none
    }
}
