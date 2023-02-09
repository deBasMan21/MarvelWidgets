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
    private static let baseUrl = "https://serverbuijsen.nl/api"
    private static let apiKey = "Bearer 3845c5d0fb08c257c2b4ac20b926763beda3a63b7cbb1c3f5c4df0851300934b77ffb693d8819a4e274f0006554990f3d6354bc43abd65ad218a0d42bb71fc670a5f0a16a631a21efd62bd236dcf876d00e655facc2467fb76181f748395a9481de2890a79c6a909eba44f3df2aecf5ae7830dd1bb83b162372bb4961971eb64"
    
    enum UrlFilterComponents: String {
        case filterMovie = "filters[type][$eq]=Movie"
        case filterSerie = "filters[type][$eq]=Serie"
        case filterSpecial = "filters[type][$eq]=Special"
        
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
        case populateDeep = "populate=deep&pagination[pageSize]=100"
        case populateNormal = "populate=%2A&pagination[pageSize]=100"
        case populateNone = "populate[0]=Posters&pagination[pageSize]=100"
    }
    
    static func getAll(populate: UrlPopulateComponents = .populateNone, force: Bool = false) async -> [ProjectWrapper] {
        let url = "\(baseUrl)/mcu-projects?\(populate.rawValue)"
        do {
            let cachedResult: ListResponseWrapper? = CachingService.getFromCache(key: WidgetType.all.rawValue)
            
            if let cachedResult = cachedResult, !force {
                Task {
                    let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: apiKey)
                    
                    CachingService.saveToCache(result: result, key: WidgetType.all.rawValue)
                }
                
                return cachedResult.data
            } else {
                let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: apiKey)
                
                CachingService.saveToCache(result: result, key: WidgetType.all.rawValue)
                
                return result?.data ?? []
            }
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getByType(_ type: WidgetType, populate: UrlPopulateComponents = .populateNone, force: Bool = false) async -> [ProjectWrapper] {
        let url = "\(baseUrl)/mcu-projects?\(UrlFilterComponents.getFilterForType(type))&\(populate.rawValue)"
        do {
            let cachedResult: ListResponseWrapper? = CachingService.getFromCache(key: type.rawValue)
            
            if let cachedResult = cachedResult, !force {
                Task {
                    let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: apiKey)
                    
                    CachingService.saveToCache(result: result, key: UserDefaultValues.cachedMovies)
                }
                
                return cachedResult.data
            } else {
                let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: apiKey)
                
                CachingService.saveToCache(result: result, key: UserDefaultValues.cachedMovies)
                
                return result?.data ?? []
            }
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getById(_ id: Int, populate: UrlPopulateComponents = .populateDeep, force: Bool = false) async -> ProjectWrapper? {
        let url = "\(baseUrl)/mcu-projects/\(id)?\(populate.rawValue)"
        do {
            let cachedResult: SingleResponseWrapper? = CachingService.getFromCache(key: CachingService.CachingKeys.project(id: "\(id)").getString())
            
            if let cachedResult = cachedResult, !force {
                Task {
                    let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: SingleResponseWrapper.self, auth: apiKey)
                    
                    CachingService.saveToCache(result: result, key: CachingService.CachingKeys.project(id: "\(id)").getString())
                }
                
                return cachedResult.data
            } else {
                let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: SingleResponseWrapper.self, auth: apiKey)
                
                CachingService.saveToCache(result: result, key: CachingService.CachingKeys.project(id: "\(id)").getString())
                
                return result?.data
            }
            
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
    
    static func getOtherByType(_ type: ProjectType, populate: UrlPopulateComponents = .populateNone, force: Bool = false) async -> [ProjectWrapper] {
        let url = "\(baseUrl)/related-projects?\(UrlFilterComponents.emptyFilter.rawValue)\(type.rawValue)&\(populate.rawValue)"
        do {
            let cachedResult: ListResponseWrapper? = CachingService.getFromCache(key: type.rawValue)
            
            if let cachedResult = cachedResult, !force {
                Task {
                    let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: apiKey)
                    
                    CachingService.saveToCache(result: result, key: type.rawValue)
                }
                
                return cachedResult.data
            } else {
                let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: apiKey)
                
                CachingService.saveToCache(result: result, key: type.rawValue)
                
                return result?.data ?? []
            }
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getOtherById(_ id: Int, populate: UrlPopulateComponents = .populateDeep, force: Bool = false) async -> ProjectWrapper? {
        let url = "\(baseUrl)/related-projects/\(id)?\(populate.rawValue)"
        do {
            let cachedResult: SingleResponseWrapper? = CachingService.getFromCache(key: CachingService.CachingKeys.otherProject(id: "\(id)").getString())
            
            if let cachedResult = cachedResult, !force {
                Task {
                    let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: SingleResponseWrapper.self, auth: apiKey)
                    
                    CachingService.saveToCache(result: result, key: CachingService.CachingKeys.otherProject(id: "\(id)").getString())
                }
                
                return cachedResult.data
            } else {
                let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: SingleResponseWrapper.self, auth: apiKey)
                
                CachingService.saveToCache(result: result, key: CachingService.CachingKeys.otherProject(id: "\(id)").getString())
                
                return result?.data
            }
            
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
    
    static func getDirectors(populate: UrlPopulateComponents = .populateNormal, force: Bool = false) async -> [DirectorsWrapper] {
        let url = "\(baseUrl)/directors?\(populate.rawValue)"
        do {
            let cachedResult: Directors? = CachingService.getFromCache(key: CachingService.CachingKeys.directors.getString())
            
            if let cachedResult = cachedResult, !force {
                Task {
                    let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: Directors.self, auth: apiKey)
                    
                    CachingService.saveToCache(result: result, key: CachingService.CachingKeys.directors.getString())
                }
                
                return cachedResult.data
            } else {
                let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: Directors.self, auth: apiKey)
                
                CachingService.saveToCache(result: result, key: CachingService.CachingKeys.directors.getString())
                
                return result?.data ?? []
            }
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getActors(populate: UrlPopulateComponents = .populateNormal, force: Bool = false) async -> [ActorsWrapper] {
        let url = "\(baseUrl)/actors?\(populate.rawValue)"
        do {
            let cachedResult: Actors? = CachingService.getFromCache(key: CachingService.CachingKeys.actors.getString())
            
            if let cachedResult = cachedResult, !force {
                Task {
                    let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: Actors.self, auth: apiKey)
                    
                    CachingService.saveToCache(result: result, key: CachingService.CachingKeys.actors.getString())
                }
                
                return cachedResult.data
            } else {
                let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: Actors.self, auth: apiKey)
                
                CachingService.saveToCache(result: result, key: CachingService.CachingKeys.actors.getString())
                
                return result?.data ?? []
            }
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
}
