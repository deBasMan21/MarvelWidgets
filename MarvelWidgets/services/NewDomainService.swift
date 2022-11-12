//
//  NewDomainService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/11/2022.
//

import Foundation

class NewDomainService {
    private static let baseUrl = "https://serverbuijsen.nl/api/mcu-projects"
    private static let apiKey = "Bearer 3845c5d0fb08c257c2b4ac20b926763beda3a63b7cbb1c3f5c4df0851300934b77ffb693d8819a4e274f0006554990f3d6354bc43abd65ad218a0d42bb71fc670a5f0a16a631a21efd62bd236dcf876d00e655facc2467fb76181f748395a9481de2890a79c6a909eba44f3df2aecf5ae7830dd1bb83b162372bb4961971eb64"
    
    enum UrlComponents: String {
        case populateDeep = "populate=deep"
        case populateNormal = "populate=%2A"
        case filterMovie = "filters[type][$eq]=Movie"
        case filterSerie = "filters[type][$eq]=Serie"
        case filterSpecial = "filters[type][$eq]=Special"
        
        static func getFilterForType(_ type: WidgetType) -> String {
            switch type {
            case .movies:
                return UrlComponents.filterMovie.rawValue
            case .series:
                return UrlComponents.filterSerie.rawValue
            case .special:
                return UrlComponents.filterSpecial.rawValue
            default:
                return ""
            }
        }
    }
    
    static func getAll() async -> [ProjectWrapper] {
        let url = "\(baseUrl)?\(UrlComponents.populateNormal.rawValue)"
        do {
            let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: apiKey)
            
            CachingService.saveToLocalStorage(result, forKey: UserDefaultValues.cachedMovies)
            
            return result?.data ?? []
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getByType(_ type: WidgetType) async -> [ProjectWrapper] {
        let url = "\(baseUrl)?\(UrlComponents.getFilterForType(type))&\(UrlComponents.populateDeep.rawValue)"
        do {
            let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: ListResponseWrapper.self, auth: apiKey)
            
            CachingService.saveToLocalStorage(result, forKey: UserDefaultValues.cachedMovies)
            
            return result?.data ?? []
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getById(_ id: Int) async -> ProjectWrapper? {
        let url = "\(baseUrl)/\(id)?\(UrlComponents.populateDeep.rawValue)"
        do {
            let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: SingleResponseWrapper.self, auth: apiKey)
            
            CachingService.saveToLocalStorage(result, forKey: UserDefaultValues.cachedMovies)
            
            return result?.data
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
}
