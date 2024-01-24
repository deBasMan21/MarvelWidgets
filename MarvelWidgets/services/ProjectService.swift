//
//  ProjectService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/11/2022.
//

import Foundation
import DataCache
import SwiftUI

// MARK:  MCU Projects
class ProjectService: Service {
    static func getAll(populate: UrlPopulateComponents = .populatePosters, force: Bool = false) async -> [ProjectWrapper] {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .project)
            .addPopulate(type: populate)
            .getString()
        
        let result: ListResponseWrapper? = await getPrivate(url: url, force: force, cachingKey: .projects)
        return result?.data ?? []
    }
    
    static func getFirstUpcoming(for type: WidgetType, source: ProjectSource?, populate: UrlPopulateComponents = .populatePosters, force: Bool) async -> [ProjectWrapper] {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .project)
            .addSourceProjectFilter(type: source)
            .addTypeFilter(type: type)
            .addFirstUpcomingFilter()
            .addPopulate(type: populate)
            .getString()
        
        let result: ListResponseWrapper? = await getPrivate(url: url, force: force, cachingKey: .none)
        return result?.data ?? []
    }
    
    static func getByType(_ type: WidgetType, populate: UrlPopulateComponents = .populatePosters, force: Bool = false) async -> [ProjectWrapper] {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .project)
            .addMcuProjectFilter()
            .addTypeFilter(type: type)
            .addPopulate(type: populate)
            .getString()
        
        let result: ListResponseWrapper? = await getPrivate(url: url, force: force, cachingKey: .none)
        return result?.data ?? []
    }
    
    static func getByTypeAndSource(type: WidgetType, source: ProjectSource?, populate: UrlPopulateComponents, force: Bool) async -> [ProjectWrapper] {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .project)
            .addTypeFilter(type: type)
            .addSourceProjectFilter(type: source)
            .addPopulate(type: populate)
            .getString()
        
        let result: ListResponseWrapper? = await getPrivate(url: url, force: force, cachingKey: .none)
        return result?.data ?? []
    }
    
    static func getById(_ id: Int, populate: UrlPopulateComponents = .populateNormalWithRelatedPosters, force: Bool = false) async -> ProjectWrapper? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .project)
            .addId(id: "\(id)")
            .addPopulate(type: populate)
            .getString()
        
        let result: SingleResponseWrapper? = await getPrivate(url: url, force: force, cachingKey: .none)
        return result?.data
    }
    
    static func getAllWithFilterAndSortKey(filterAndSortKey: String, limitItems: Int) async -> [ProjectWrapper]? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .project)
            .addCustomFilterAndSortKey(key: filterAndSortKey)
            .addPopulate(type: .populatePosters)
            .addPagination(pageSize: limitItems, page: 1)
            .getString()
        
        let result: ListResponseWrapper? = await getPrivate(url: url, force: true, cachingKey: .none)
        return result?.data
    }
}
