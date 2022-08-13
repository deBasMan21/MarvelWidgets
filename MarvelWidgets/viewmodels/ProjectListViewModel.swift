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
                return "Marvel Projects"
            case .movies:
                return "Marvel Movies"
            case .series:
                return "Marvel Series"
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
                        let defs = UserDefaults(suiteName: UserDefaultValues.savedProjects)!
                        let ids: [String] = defs.array(forKey: UserDefaultValues.savedProjectIds) as? [String] ?? []
                        projects = getProjectsFromUserDefaults(for: ids)
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
        
        func getProjectsFromUserDefaults(for ids: [String]) -> [Project] {
            let defs = UserDefaults(suiteName: UserDefaultValues.savedProjects)!
            var projects: [Project] = []
            
            for id in ids {
                let decoder = JSONDecoder()
                let projData = defs.data(forKey: id)
                
                if let data = projData {
                    if id.starts(with: "s") {
                        let proj = try? decoder.decode(Serie.self, from: data)
                        if let proj = proj {
                            projects.append(proj)
                        }
                    } else if id.starts(with: "m") {
                        let proj = try? decoder.decode(Movie.self, from: data)
                        if let proj = proj {
                            projects.append(proj)
                        }
                    }
                }
            }
            
            return projects
        }
    }
    
    enum OrderType: String, CaseIterable {
        case nameASC = "Name A-Z"
        case nameDESC = "Name Z-A"
        case releaseDateASC = "Release date (new-old)"
        case releaseDateDESC = "Release date (old-new)"
    }
}
