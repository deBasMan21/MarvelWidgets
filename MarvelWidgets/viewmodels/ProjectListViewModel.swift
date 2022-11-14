//
//  ProjectListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation

extension ProjectListView {
    class ProjectListViewModel: ObservableObject {
        @Published var projects: [ProjectWrapper] = []
        @Published var orderType: OrderType = .releaseDateASC
        @Published var pageType: WidgetType = .all
        
        var navigationTitle: String {
            switch pageType {
            case .all:
                return "MCU Projects"
            case .movies:
                return "MCU Movies"
            case .series:
                return "MCU Series"
            case .special:
                return "MCU Specials"
            case .saved:
                return "Saved Projects"
            }
        }
        
        func fetchProjects() async {
            _ = await MainActor.run {
                Task {
                    var projects: [ProjectWrapper]
                    switch pageType {
                    case .all:
                        projects = await ProjectService.getAll()
                    case .movies, .series, .special:
                        projects = await ProjectService.getByType(pageType)
                    case .saved:
                        projects = SaveService.getProjectsFromUserDefaults()
                    }
                    
                    
                    
                    self.projects = orderProjects(projects, by: orderType)
                }
            }
        }
        
        func orderProjects(_ projects: [ProjectWrapper], by orderType: OrderType) -> [ProjectWrapper] {
            var orderedProjects: [ProjectWrapper]
            self.orderType = orderType
            switch orderType {
            case .nameASC:
                orderedProjects = projects.sorted(by: { $0.attributes.title < $1.attributes.title})
            case .nameDESC:
                orderedProjects = projects.sorted(by: { $0.attributes.title > $1.attributes.title})
            case .releaseDateASC:
                orderedProjects = projects.sorted(by: { $0.attributes.releaseDate ?? "3000-12-12" > $1.attributes.releaseDate ?? "3000-12-12" })
            case .releaseDateDESC:
                orderedProjects = projects.sorted(by: { $0.attributes.releaseDate ?? "3000-12-12" < $1.attributes.releaseDate ?? "3000-12-12" })
            }
            return orderedProjects
        }
        
        func orderProjects(by orderType: OrderType) {
            projects = orderProjects(projects, by: orderType)
        }
        
        func refresh() async {
            await fetchProjects()
        }
    }
    
    enum OrderType: String, CaseIterable {
        case nameASC = "Name A-Z"
        case nameDESC = "Name Z-A"
        case releaseDateASC = "Release date (new-old)"
        case releaseDateDESC = "Release date (old-new)"
    }
}
