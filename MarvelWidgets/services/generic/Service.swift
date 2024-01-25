//
//  Service.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation

class Service {
    internal static var config: Config {
        if UserDefaultsService.standard.useConfig,
            !UserDefaultsService.standard.token.isEmpty,
            !UserDefaultsService.standard.baseUrl.isEmpty {
            return DebugConfig.standard
        } else {
            return ProductionConfig.standard
        }
    }
    
    enum CachingKeys: String {
        case projects = "project"
        case actor = "actors"
        case director = "directors"
        case none = ""
    }
    
    internal static func getPrivate<T: Codable>(url: String, force: Bool, cachingKey: CachingKeys) async -> T? {
        do {
            let cachedResult: T? = CachingService.getFromCache(key: cachingKey.rawValue)
            
            if let cachedResult = cachedResult, !force, cachingKey != .none {
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
