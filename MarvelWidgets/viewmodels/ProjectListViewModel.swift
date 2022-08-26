//
//  ProjectListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation

extension ProjectListView {
    class ProjectListViewModel: ObservableObject {
        @Published var projects: [Project] = []
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
            case .saved:
                return "Saved Projects"
            }
        }
        
        func fetchProjects() async {
            _ = await MainActor.run {
                Task {
                    var projects: [Project]
                    switch pageType {
                    case .all:
                        projects = await MovieService.getMoviesChronologically()
                        projects.append(contentsOf: await SeriesService.getSeriesChronologically())
                    case .movies:
                        projects = await MovieService.getMoviesChronologically()
                    case .series:
                        projects = await SeriesService.getSeriesChronologically()
                    case .saved:
                        projects = SaveService.getProjectsFromUserDefaults()
                    }
                    self.projects = orderProjects(projects, by: orderType)
                }
            }
        }
        
        func orderProjects(_ projects: [Project], by orderType: OrderType) -> [Project] {
            var orderedProjects: [Project]
            self.orderType = orderType
            switch orderType {
            case .nameASC:
                orderedProjects = projects.sorted(by: { $0.title < $1.title})
            case .nameDESC:
                orderedProjects = projects.sorted(by: { $0.title > $1.title})
            case .releaseDateASC:
                orderedProjects = projects.sorted(by: { $0.releaseDate ?? "3000-12-12" > $1.releaseDate ?? "3000-12-12" })
            case .releaseDateDESC:
                orderedProjects = projects.sorted(by: { $0.releaseDate ?? "3000-12-12" < $1.releaseDate ?? "3000-12-12" })
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
