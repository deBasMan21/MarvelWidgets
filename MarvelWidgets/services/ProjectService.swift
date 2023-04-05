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
    static var config: Config = ProductionConfig()
    
    enum UrlFilterComponents: String {
        case filterMovie = "filters[type][$eq]=Movie"
        case filterSerie = "filters[type][$eq]=Serie"
        case filterSpecial = "filters[type][$eq]=Special"
        case firstUpcoming = "populate[0]=Posters&populate[1]=directors&sort[0]=ReleaseDate:asc&filters[ReleaseDate][$gt]=2023-02-25&pagination[pageSize]=2"
        
        case emptyFilter = "filters[type][$eq]="
        
        static func getFilterForType(_ type: WidgetType) -> String {
            switch type {
            case .movies:
                return UrlFilterComponents.filterMovie.rawValue
            case .series:
                return UrlFilterComponents.filterSerie.rawValue
            case .special:
                return UrlFilterComponents.filterSpecial.rawValue
            default:
                return ""
            }
        }
    }
    
    enum UrlPopulateComponents: String {
        case populateNone = ""
        case populateDeep = "populate=deep"
        case populateNormal = "populate=%2A"
        case populatePosters = "populate[0]=Posters"
        case populatePersonPosters = "populate[0]=related_projects&populate[1]=related_projects.Posters&populate=*&populate[2]=mcu_projects&populate[3]=mcu_projects.Posters"
        case populateNormalWithRelatedPosters = "populate[0]=related_projects.Posters&populate[1]=Posters&populate[2]=Trailers&populate[3]=actors&populate[4]=directors&populate[5]=Seasons&populate[6]=Seasons.Episodes"
    }
    
    static func getAll(populate: UrlPopulateComponents = .populatePosters, force: Bool = false) async -> [ProjectWrapper] {
        let url = "\(config.baseUrl)/mcu-projects?\(populate.rawValue)"
        do {
            let cachedResult: ListResponseWrapper? = CachingService.getFromCache(key: ListPageType.mcu.rawValue)
            
            if let cachedResult = cachedResult, !force {
                Task {
                    let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: config.apiKey)
                    
                    print("debug: result \(result?.data)")
                    
                    CachingService.saveToCache(result: result, key: ListPageType.mcu.rawValue)
                }
                
                return cachedResult.data
            } else {
                let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: config.apiKey)
                
                CachingService.saveToCache(result: result, key: ListPageType.mcu.rawValue)
                
                print("debug: result \(result?.data)")
                return result?.data ?? []
            }
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getFirstUpcoming(for type: WidgetType) async -> [ProjectWrapper] {
        let typeFilter = UrlFilterComponents.getFilterForType(type)
        let filterString = typeFilter.isEmpty ? "" : "&\(typeFilter)"
        let url = "\(config.baseUrl)/mcu-projects?\(UrlFilterComponents.firstUpcoming.rawValue)\(filterString)"
        do {
            let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: config.apiKey)
            return result?.data ?? []
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getByType(_ type: WidgetType, populate: UrlPopulateComponents = .populatePosters, force: Bool = false) async -> [ProjectWrapper] {
        let url = "\(config.baseUrl)/mcu-projects?\(UrlFilterComponents.getFilterForType(type))&\(populate.rawValue)"
        do {
            let cachedResult: ListResponseWrapper? = CachingService.getFromCache(key: type.rawValue)
            
            if let cachedResult = cachedResult, !force {
                Task {
                    let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: config.apiKey)
                    
                    CachingService.saveToCache(result: result, key: type.rawValue)
                }
                
                return cachedResult.data
            } else {
                let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: config.apiKey)
                
                CachingService.saveToCache(result: result, key: type.rawValue)
                
                return result?.data ?? []
            }
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getById(_ id: Int, populate: UrlPopulateComponents = .populateNormalWithRelatedPosters, force: Bool = false) async -> ProjectWrapper? {
        let url = "\(config.baseUrl)/mcu-projects/\(id)?\(populate.rawValue)"
        do {
            return try await APIService.apiCall(url: url, body: nil, method: "GET", as: SingleResponseWrapper.self, auth: config.apiKey)?.data
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
    
    static func getAllOther(populate: UrlPopulateComponents = .populatePosters, force: Bool = false) async -> [ProjectWrapper] {
        let url = "\(config.baseUrl)/related-projects?\(populate.rawValue)"
        do {
            let cachedResult: ListResponseWrapper? = CachingService.getFromCache(key: ListPageType.other.rawValue)
            
            if let cachedResult = cachedResult, !force {
                Task {
                    let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: config.apiKey)
                    
                    CachingService.saveToCache(result: result, key: ListPageType.other.rawValue)
                }
                
                return cachedResult.data
            } else {
                let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: config.apiKey)
                
                CachingService.saveToCache(result: result, key: ListPageType.other.rawValue)
                
                return result?.data ?? []
            }
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getOtherById(_ id: Int, populate: UrlPopulateComponents = .populateNormalWithRelatedPosters, force: Bool = false) async -> ProjectWrapper? {
        let url = "\(config.baseUrl)/related-projects/\(id)?\(populate.rawValue)"
        do {
            return try await APIService.apiCall(url: url, body: nil, method: "GET", as: SingleResponseWrapper.self, auth: config.apiKey)?.data
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
    
    static func getDirectors(populate: UrlPopulateComponents = .populatePosters, force: Bool = false) async -> [DirectorsWrapper] {
        let url = "\(config.baseUrl)/directors?\(populate.rawValue)"
        do {
            let cachedResult: Directors? = CachingService.getFromCache(key: CachingService.CachingKeys.directors.getString())
            
            if let cachedResult = cachedResult, !force {
                Task {
                    let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: Directors.self, auth: config.apiKey)
                    
                    CachingService.saveToCache(result: result, key: CachingService.CachingKeys.directors.getString())
                }
                
                return cachedResult.data
            } else {
                let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: Directors.self, auth: config.apiKey)
                
                CachingService.saveToCache(result: result, key: CachingService.CachingKeys.directors.getString())
                
                return result?.data ?? []
            }
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getActors(populate: UrlPopulateComponents = .populatePosters, force: Bool = false) async -> [ActorsWrapper] {
        let url = "\(config.baseUrl)/actors?\(populate.rawValue)"
        do {
            let cachedResult: Actors? = CachingService.getFromCache(key: CachingService.CachingKeys.actors.getString())
            
            if let cachedResult = cachedResult, !force {
                Task {
                    let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: Actors.self, auth: config.apiKey)
                    
                    CachingService.saveToCache(result: result, key: CachingService.CachingKeys.actors.getString())
                }
                
                return cachedResult.data
            } else {
                let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: Actors.self, auth: config.apiKey)
                
                CachingService.saveToCache(result: result, key: CachingService.CachingKeys.actors.getString())
                
                return result?.data ?? []
            }
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getActorById(id: Int, force: Bool = false) async -> ActorsWrapper? {
        let url = "\(config.baseUrl)/actors/\(id)?\(UrlPopulateComponents.populatePersonPosters.rawValue)"
        do {
            return try await APIService.apiCall(url: url, body: nil, method: "GET", as: SingleActor.self, auth: config.apiKey)?.data
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
    
    static func getDirectorById(id: Int, force: Bool = false) async -> DirectorsWrapper? {
        let url = "\(config.baseUrl)/directors/\(id)?\(UrlPopulateComponents.populatePersonPosters.rawValue)"
        do {
            return try await APIService.apiCall(url: url, body: nil, method: "GET", as: SignleDirector.self, auth: config.apiKey)?.data
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
}
