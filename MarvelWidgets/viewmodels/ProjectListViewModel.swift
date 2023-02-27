//
//  ProjectListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation
import SwiftUI

extension ProjectListView {
    class ProjectListViewModel: ObservableObject {
        @Published var pageType: ListPageType = .mcu {
            didSet {
                switch pageType {
                case .mcu:
                    typeFilters = [.movie, .serie, .special]
                case .other:
                    typeFilters = [.defenders, .fox, .sony, .marvelTelevision, .marvelOther]
                }
                
                updateScrollButton()
            }
        }
        @Published var typeFilters: [ProjectType] = []
        @Published var showFilters: Bool = false
        private var allProjects: [ProjectWrapper] = [] {
            didSet {
                afterDate = allProjects.compactMap { $0.attributes.releaseDate?.toDate() }.min() ?? Date.now
                beforeDate = allProjects.compactMap { $0.attributes.releaseDate?.toDate() }.max() ?? Date.now
            }
        }
        @Published var projects: [ProjectWrapper] = []
        @Published var closestDateId: Int = -1
        @Published var showScroll: Bool = false
        @Published var forceClose: Bool = false
        @Published var orderType: OrderType = .releaseDateASC
        @Published var selectedFilters: [Phase] = [] {
            didSet {
                filterProjects()
            }
        }
        @Published var selectedTypes: [ProjectType] = [] {
            didSet {
                filterProjects()
            }
        }
        @Published var searchQuery: String = "" {
            didSet {
                filterProjects()
            }
        }
        @Published var beforeDate: Date = Date.now {
            didSet {
                filterProjects()
            }
        }
        
        @Published var afterDate: Date = Date.now {
            didSet {
                filterProjects()
            }
        }
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        var navigationTitle: String {
            switch pageType {
            case .mcu:
                return "MCU Projects"
            case .other:
                return "Marvel other"
            }
        }
        
        func fetchProjects(force: Bool = false) async {
            _ = await MainActor.run {
                Task {
                    var projects: [ProjectWrapper] = []
                    switch pageType {
                    case .mcu:
                        projects = await ProjectService.getAll(force: force)
                    case .other:
                        projects = await ProjectService.getAllOther(force: force)
                    }
                    
                    allProjects = orderProjects(projects, by: orderType)
                    filterProjects()
                    
                    closestDateId = projects.getClosest()
                    showScroll = true
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
            withAnimation {
                projects = orderProjects(projects, by: orderType)
            }
        }
        
        func refresh(force: Bool = false) async {
            await fetchProjects(force: force)
        }
        
        func filterProjects() {
            withAnimation {
                projects = allProjects.filter {
                    guard let projDate = $0.attributes.releaseDate?.toDate() else { return true }
                    return projDate > afterDate && projDate < beforeDate
                }
                
                if selectedFilters.count > 0 {
                    projects = projects.filter { selectedFilters.contains($0.attributes.phase ?? .unkown) }
                }
                
                if selectedTypes.count > 0 {
                    projects = projects.filter { selectedTypes.contains($0.attributes.type) }
                }
                
                if !searchQuery.isEmpty {
                    projects = projects.filter { $0.attributes.title.contains(searchQuery) }
                }
            }
            
            updateScrollButton()
        }
        
        func updateScrollButton() {
            withAnimation {
                forceClose = pageType != .mcu || selectedTypes.count != 0 || selectedFilters.count != 0 || !searchQuery.isEmpty
            }
        }
    }
    
    enum OrderType: String, CaseIterable {
        case nameASC = "Name A-Z"
        case nameDESC = "Name Z-A"
        case releaseDateASC = "Release date (new-old)"
        case releaseDateDESC = "Release date (old-new)"
    }
}
