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
        @Published var orderType: OrderType = .releaseDate
        @Published var pageType: WidgetType = .all
        var navigationTitle: String {
            switch pageType {
            case .all:
                return "Marvel Projects"
            case .movies:
                return "Marvel Movies"
            case .series:
                return "Marvel Series"
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
            case .releaseDate:
                orderedProjects = projects.sorted(by: {
                    let dateOne: Date = $0.releaseDate?.toDate() ?? "3000-12-12".toDate()!
                    let dateTwo: Date = $1.releaseDate?.toDate() ?? "3000-12-12".toDate()!
                    return dateOne > dateTwo
                })
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
        case nameASC = "Naam A-Z"
        case nameDESC = "Naam Z-A"
        case releaseDate = "Release datum"
    }
}
