//
//  ProjectService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/11/2022.
//

import Foundation
import DataCache
import SwiftUI

class ProjectService {
    static var config: Config {
        if UserDefaultsService.standard.useConfig,
            !UserDefaultsService.standard.token.isEmpty,
            !UserDefaultsService.standard.baseUrl.isEmpty {
            return DebugConfig.standard
        } else {
            return ProductionConfig.standard
        }
    }
}
/// All lists of items are being cached to improve response times. These are: all mcu, all related, all directors, all actors.
/// All details of items are not cached to always show the most recent data.

// MARK:  MCU Projects
extension ProjectService {
    static func getAll(for type: ListPageType = .mcu, populate: UrlPopulateComponents = .populatePosters, force: Bool = false) async -> [ProjectWrapper] {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .project)
            .addMcuOrRelatedFilter(type: type)
            .addPopulate(type: populate)
            .getString()
        
        let result: ListResponseWrapper? = await getPrivate(url: url, force: force, cachingKey: CachingKeys.getFromListPageType(type: type))
        return result?.data ?? []
    }
    
    static func getFirstUpcoming(for type: WidgetType) async -> [ProjectWrapper] {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .project)
            .addMcuProjectFilter()
            .addTypeFilter(type: type)
            .addFirstUpcomingFilter()
            .getString()
        
        let result: ListResponseWrapper? = await getPrivate(url: url, force: true, cachingKey: .none)
        return result?.data ?? []
    }
    
    static func getByType(_ type: WidgetType, populate: UrlPopulateComponents = .populatePosters, force: Bool = false) async -> [ProjectWrapper] {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .project)
            .addMcuProjectFilter()
            .addTypeFilter(type: type)
            .addPopulate(type: populate)
            .getString()
        
        let result: ListResponseWrapper? = await getPrivate(url: url, force: true, cachingKey: .none)
        return result?.data ?? []
    }
    
    static func getById(_ id: Int, populate: UrlPopulateComponents = .populateNormalWithRelatedPosters, force: Bool = false) async -> ProjectWrapper? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .project)
            .addId(id: "\(id)")
            .addPopulate(type: populate)
            .getString()
        
        let result: SingleResponseWrapper? = await getPrivate(url: url, force: true, cachingKey: .none)
        return result?.data
    }
}

// MARK: Persons
extension ProjectService {
    static func getDirectors(force: Bool = false) async -> [DirectorsWrapper] {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .director)
            .getString()
        
        let result: Directors? = await getPrivate(url: url, force: force, cachingKey: .director)
        return result?.data ?? []
    }
    
    static func getActors(force: Bool = false) async -> [ActorsWrapper] {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .actor)
            .getString()
        
        let result: Actors? = await getPrivate(url: url, force: force, cachingKey: .actor)
        return result?.data ?? []
    }
    
    static func getActorById(id: Int, force: Bool = false) async -> ActorsWrapper? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .actor)
            .addId(id: "\(id)")
            .addPopulate(type: .populatePersonPosters)
            .getString()
        
        let result: SingleActor? = await getPrivate(url: url, force: true, cachingKey: .none)
        return result?.data
    }
    
    static func getDirectorById(id: Int, force: Bool = false) async -> DirectorsWrapper? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .director)
            .addId(id: "\(id)")
            .addPopulate(type: .populatePersonPosters)
            .getString()
        
        let result: SignleDirector? = await getPrivate(url: url, force: true, cachingKey: .none)
        return result?.data
    }
}

// MARK: Helper
extension ProjectService {
    enum CachingKeys: String {
        case mcu = "mcuProjects"
        case related = "relatedProjects"
        case actor = "actors"
        case director = "directors"
        case none = ""
        
        static func getFromListPageType(type: ListPageType) -> CachingKeys {
            switch type {
            case .mcu: return .mcu
            case .other: return .related
            }
        }
    }
    
    private static func getPrivate<T: Codable>(url: String, force: Bool, cachingKey: CachingKeys) async -> T? {
        do {
            let cachedResult: T? = CachingService.getFromCache(key: cachingKey.rawValue)
            
            if let cachedResult = cachedResult, !force {
                Task {
                    let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: T.self, auth: config.apiKey)
                    
                    CachingService.saveToCache(result: result, key: cachingKey.rawValue)
                }
                
                return cachedResult
            } else {
                let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: T.self, auth: config.apiKey)
                
                CachingService.saveToCache(result: result, key: cachingKey.rawValue)
                
                return result
            }
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
}
