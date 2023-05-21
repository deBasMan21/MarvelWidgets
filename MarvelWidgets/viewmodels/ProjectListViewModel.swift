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
        var filterCallback: (Bool, Int) -> Void = { _, _ in }
        
        @Published var scrollViewHeight: CGFloat = 0
        @Published var proportion: CGFloat = 0
        @Published var proportionName: String = "scroll"
        @Published var pageType: ListPageType = .mcu {
            didSet {
                switch pageType {
                case .mcu:
                    typeFilters = [.movie, .serie, .special]
                case .other:
                    typeFilters = [.defenders, .fox, .sony, .marvelTelevision, .marvelOther]
                }
            }
        }
        @Published var typeFilters: [ProjectType] = []
        @Published var showFilters: Bool = false
        private var allProjects: [ProjectWrapper] = []
        @Published var projects: [ProjectWrapper] = []
        @Published var selectedCategories: [String] = [] {
            didSet {
                filterProjects()
            }
        }
        @Published var orderType: OrderType = .releaseDateASC {
            didSet {
                orderProjects()
            }
        }
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
        
        private var blockFilter: Bool = false
        private var minimalBeforeDate: Date = Date.now
        private var maximalAfterDate: Date = Date.now
        
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
        
        init(pageType: ListPageType) {
            self.pageType = pageType
        }
        
        func fetchProjects(force: Bool = false) async {
            allProjects = await ProjectService.getAll(for: pageType, force: force)
            
            filterProjects()
            orderProjects()
            setReleaseDates(save: true)
        }
        
        func setReleaseDates(save: Bool = false) {
            Task {
                let afterDateList = allProjects.compactMap { $0.attributes.releaseDate?.toDate() }.min()?.addingTimeInterval(-60 * 60 * 24) ?? Date.now
                let beforeDateList = allProjects.compactMap { $0.attributes.releaseDate?.toDate() }.max()?.addingTimeInterval(60 * 60 * 24) ?? Date.now
                
                await MainActor.run {
                    afterDate = afterDateList
                    beforeDate = beforeDateList
                    
                    if save {
                        minimalBeforeDate = beforeDate
                        maximalAfterDate = afterDate
                    }
                }
            }
            
        }
        
        func orderProjects() {
            projects = orderProjects(projects: projects)
        }
        
        func orderProjects(projects: [ProjectWrapper]) -> [ProjectWrapper] {
            var orderedProjects: [ProjectWrapper] = projects
            
            switch orderType {
            case .nameASC:
                orderedProjects = projects.sorted(by: { $0.attributes.title < $1.attributes.title})
            case .nameDESC:
                orderedProjects = projects.sorted(by: { $0.attributes.title > $1.attributes.title})
            case .releaseDateASC:
                orderedProjects = projects.sorted(by: { $0.attributes.releaseDate ?? "3000-12-12" > $1.attributes.releaseDate ?? "3000-12-12" })
            case .releaseDateDESC:
                orderedProjects = projects.sorted(by: { $0.attributes.releaseDate ?? "3000-12-12" < $1.attributes.releaseDate ?? "3000-12-12" })
            case .ratingASC:
                orderedProjects = projects.sorted(by: {
                    let rating0 = $0.attributes.rating ?? 0
                    let rating1 = $1.attributes.rating ?? 0
                    if rating0 == rating1 {
                        return $0.attributes.voteCount ?? 0 < $1.attributes.voteCount ?? 0
                    } else {
                        return rating0 < rating1
                    }
                })
            case .ratingDESC:
                orderedProjects = projects.sorted(by: {
                    let rating0 = $0.attributes.rating ?? 0
                    let rating1 = $1.attributes.rating ?? 0
                    if rating0 == rating1 {
                        return $0.attributes.voteCount ?? 0 > $1.attributes.voteCount ?? 0
                    } else {
                        return rating0 > rating1
                    }
                })
            case .rankingASC:
                orderedProjects = projects.sorted(by: {
                    let rating0 = $0.attributes.rankingCurrentRank ?? 10000
                    let rating1 = $1.attributes.rankingCurrentRank ?? 10000
                    if rating0 == rating1 {
                        return $0.attributes.voteCount ?? 0 > $1.attributes.voteCount ?? 0
                    } else {
                        return rating0 > rating1
                    }
                })
            case .rankingDESC:
                orderedProjects = projects.sorted(by: {
                    let rating0 = $0.attributes.rankingCurrentRank ?? 10000
                    let rating1 = $1.attributes.rankingCurrentRank ?? 10000
                    if rating0 == rating1 {
                        return $0.attributes.getRankingChange() < $1.attributes.getRankingChange()
                    } else {
                        return rating0 < rating1
                    }
                })
            case .chronology:
                orderedProjects = projects.sorted(by: {
                    return $0.attributes.chronology ?? 10000 < $1.attributes.chronology ?? 10000
                })
            }
            
            return orderedProjects
        }
        
        func refresh(force: Bool = false) async {
            await fetchProjects(force: force)
        }
        
        func filterProjects() {
            guard !blockFilter else { return }
            
            var projects = allProjects.filter {
                guard let projDate = $0.attributes.releaseDate?.toDate() else { return true }
                return projDate >= afterDate && projDate <= beforeDate
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
            
            if selectedCategories.count > 0 {
                projects = projects.filter {
                    let categories = ($0.attributes.categories ?? "").split(separator: ", ").compactMap(String.init)
                    return Set(categories).intersection(Set(selectedCategories)).count > 0
                }
            }
            
            projects = projects.filter {
                $0.attributes.releaseDate ?? "" > afterDate.toOriginalFormattedString()
            }
            
            projects = projects.filter {
                $0.attributes.releaseDate ?? "" < beforeDate.toOriginalFormattedString()
            }
            
            withAnimation {
                self.projects = orderProjects(projects: projects)
            }
            
            filterCallback(true, getFilterCount())
        }
        
        func getFilterCount() -> Int {
            var count: Int = selectedFilters.count + selectedTypes.count
            count += minimalBeforeDate == beforeDate ? 0 : 1
            count += maximalAfterDate == afterDate ? 0 : 1
            return count
        }
        
        func resetFilters() {
            blockFilter = true
            
            selectedFilters = []
            selectedTypes = []
            selectedCategories = []
            orderType = .releaseDateASC
            setReleaseDates()
            
            blockFilter = false
            filterProjects()
        }
    }
    
    enum OrderType: String, CaseIterable {
        case nameASC = "Name (A-Z)"
        case nameDESC = "Name (Z-A)"
        case releaseDateASC = "Release date (new-old)"
        case releaseDateDESC = "Release date (old-new)"
        case ratingASC = "Rating (low-high)"
        case ratingDESC = "Rating (high-low)"
        case rankingASC = "Current ranking (low-high)"
        case rankingDESC = "Current ranking (high-low"
        case chronology = "Chronological"
    }
}
