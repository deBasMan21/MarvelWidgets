//
//  UrlBuilder.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/04/2023.
//

import Foundation

// MARK: Base
class UrlBuilder: UrlBuilderType {
    private var currentUrl: String
    private var entity: Entity
    private var hasFilters: Bool = false
    
    enum Entity: String {
        case director = "directors"
        case actor = "actors"
        case project = "mcu-projects"
    }
    
    init(baseUrl: String, entity: Entity) {
        self.entity = entity
        self.currentUrl = "\(baseUrl)/\(entity.rawValue)"
    }
    
    func getString() -> String {
        return currentUrl
    }
    
    func addId(id: String) -> UrlBuilderType {
        currentUrl += "/\(id)"
        return self
    }
    
    private func addFilterParameter() {
        guard hasFilters else {
            currentUrl += "?"
            hasFilters = true
            return
        }
        
        currentUrl += "&"
    }
    
    private func isProject() -> Bool {
        return entity == .project
    }
    
    private func isPerson() -> Bool {
        return entity == .actor || entity == .director
    }
}

// MARK: Filters
extension UrlBuilder {
    func addFirstUpcomingFilter() -> UrlBuilderType {
        guard isProject() else { return self }
        addFilterParameter()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let releaseDateFilter = dateFormatter.string(from: Date())
        currentUrl += "populate[0]=Posters&populate[1]=directors&sort[0]=ReleaseDate:asc&filters[ReleaseDate][$gt]=\(releaseDateFilter)&pagination[pageSize]=2"
        
        return self
    }
    
    func addTypeFilter(type: WidgetType) -> UrlBuilderType {
        guard isProject() else { return self }
        
        switch type {
        case .movies: return addMovieFilter()
        case .series: return addSerieFilter()
        case .special: return addSpecialFilter()
        default: return self
        }
    }
    
    func addMcuOrRelatedFilter(type: ListPageType) -> UrlBuilderType {
        switch type {
        case .mcu: return addMcuProjectFilter()
        case .other: return addRelatedProjectFilter()
        }
    }
    
    func addMcuProjectFilter() -> UrlBuilderType {
        guard isProject() else { return self }
        addFilterParameter()
        currentUrl += "filters[isMCUProject][$eq]=true"
        return self
    }
    
    func addRelatedProjectFilter() -> UrlBuilderType {
        guard isProject() else { return self }
        addFilterParameter()
        currentUrl += "filters[isMCUProject][$eq]=false"
        return self
    }
    
    private func addMovieFilter() -> UrlBuilder {
        guard isProject() else { return self }
        addFilterParameter()
        currentUrl += "filters[type][$eq]=Movie"
        return self
    }
    
    private func addSerieFilter() -> UrlBuilder {
        guard isProject() else { return self }
        addFilterParameter()
        currentUrl += "filters[type][$eq]=Serie"
        return self
    }
    
    private func addSpecialFilter() -> UrlBuilder {
        guard isProject() else { return self }
        addFilterParameter()
        currentUrl += "filters[type][$eq]=Special"
        return self
    }
}

// MARK: Population
extension UrlBuilder {
    func addPopulate(type: UrlPopulateComponents) -> UrlBuilderType {
        switch type {
        case .populateNormal: return addNormalPopulate()
        case .populatePosters: return addPostersPopulate()
        case .populatePersonPosters: return addPersonPostersPopulate()
        case .populateNormalWithRelatedPosters: return addProjectDetailPopulate()
        default: return self
        }
    }
    
    private func addNormalPopulate() -> UrlBuilder {
        addFilterParameter()
        currentUrl += "populate=*"
        return self
    }
    
    private func addPostersPopulate() -> UrlBuilder {
        guard isProject() else { return self }
        addFilterParameter()
        currentUrl += "populate[0]=Posters"
        return self
    }
    
    private func addPersonPostersPopulate() -> UrlBuilder {
        guard isPerson() else { return self }
        addFilterParameter()
        currentUrl += "populate[0]=related_projects&populate[1]=related_projects.Posters&populate=*&populate[2]=mcu_projects&populate[3]=mcu_projects.Posters"
        return self
    }
    
    private func addProjectDetailPopulate() -> UrlBuilder {
        guard isProject() else { return self }
        addFilterParameter()
        currentUrl += "populate[0]=related_projects.Posters&populate[1]=Posters&populate[2]=Trailers&populate[3]=actors&populate[4]=directors&populate[5]=Seasons&populate[6]=Seasons.seasonProject&populate[7]=episodes"
        return self
    }
}
