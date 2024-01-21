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
        case collection = "collections"
        case newsItems = "news-items"
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
    
    private func isCollection() -> Bool {
        return entity == .collection
    }
    
    private func isNewsItem() -> Bool {
        return entity == .newsItems
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
        currentUrl += "sort[0]=ReleaseDate:asc&filters[ReleaseDate][$gt]=\(releaseDateFilter)&pagination[pageSize]=2"
        
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
        currentUrl += "filters[Source][$eq]=MCU"
        return self
    }
    
    func addRelatedProjectFilter() -> UrlBuilderType {
        guard isProject() else { return self }
        addFilterParameter()
        currentUrl += "filters[Source][$ne]=MCU"
        return self
    }
    
    func addSourceProjectFilter(type: ProjectSource?) -> UrlBuilderType {
        guard isProject(), let type = type else { return self }
        addFilterParameter()
        currentUrl += "filters[Source][$eq]=\(type.rawValue)"
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

// MARK: Sort
extension UrlBuilder {
    func addSortByPublishDate() -> UrlBuilderType {
        guard isNewsItem() else { return self }
        addFilterParameter()
        currentUrl += "sort[0]=date_published:desc"
        return self
    }
}

// MARK: Paging
extension UrlBuilder {
    func addPagination(pageSize: Int = 5, page: Int) -> UrlBuilderType {
        guard isNewsItem() else { return self }
        addFilterParameter()
        currentUrl += "pagination[pageSize]=\(pageSize)"
        addFilterParameter()
        currentUrl += "pagination[page]=\(page)"
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
        case .populateWidget: return addWidgetPopulate()
        case .populateCollection: return addCollectionPopulate()
        default: return self
        }
    }
    
    private func addWidgetPopulate() -> UrlBuilder {
        addFilterParameter()
        currentUrl += "populate[0]=Posters&populate[1]=directors"
        return self
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
        currentUrl += "populate=*,mcu_projects.Posters"
        return self
    }
    
    private func addProjectDetailPopulate() -> UrlBuilder {
        guard isProject() else { return self }
        addFilterParameter()
        currentUrl += "populate[0]=related_projects.Posters&populate[1]=Posters&populate[2]=Trailers&populate[3]=actors&populate[4]=directors&populate[5]=Seasons&populate[6]=Seasons.seasonProject&populate[7]=episodes&populate[8]=collection"
        return self
    }
    
    private func addCollectionPopulate() -> UrlBuilder {
        guard isCollection() else { return self }
        addFilterParameter()
        currentUrl += "populate[0]=projects&populate[1]=projects.Posters"
        return self
    }
}
