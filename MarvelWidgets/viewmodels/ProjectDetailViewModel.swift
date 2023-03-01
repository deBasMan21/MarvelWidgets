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
    @Published var project: ProjectWrapper
    @Published var showBottomLoader = true
    @Published var showAlert = false
    @Published var posterURL: String
    @Published var posterIndex: Int = 0 {
        didSet {
            withAnimation {
                posterURL = project.attributes.posters?[posterIndex].posterURL ?? ""
            }
        }
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let store = EKEventStore()
    
    init(project: ProjectWrapper) {
        self.project = project
        posterURL = project.attributes.posters?.first?.posterURL ?? ""
        
        Task {
            await refresh(id: project.id)
        }
    }
    
    func refresh(id: Int, force: Bool = false) async {
        switch project.attributes.type {
        case .sony, .defenders, .fox, .marvelOther, .marvelTelevision:
            if let populatedProject = await getPopulatedOtherProject(id, force: force) {
                await MainActor.run {
                    withAnimation {
                        self.project = populatedProject
                    }
                }
            }
        default:
            if let populatedProject = await getPopulatedProject(id, force: force) {
                await MainActor.run {
                    withAnimation {
                        self.project = populatedProject
                    }
                }
            }
        }
        
        await MainActor.run {
            withAnimation {
                showBottomLoader = false
            }
        }
    }
    
    func getPopulatedProject(_ id: Int, force: Bool) async -> ProjectWrapper? {
        return await ProjectService.getById(id, force: force)
    }
    
    func getPopulatedOtherProject(_ id: Int, force: Bool) async -> ProjectWrapper? {
        return await ProjectService.getOtherById(id, force: force)
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
                    self.showAlert = true
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
