//
//  CachingService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation
import DataCache

class CachingService {
    static func saveToCache<T: Codable>(result: T, key: String) {
        do {
            try DataCache.instance.write(codable: result, forKey: key)
            UserDefaults.standard.set(Date.now, forKey: "lastCachedDate")
        } catch let error {
            print("error: \(error)")
        }
    }
    
    static func getFromCache<T: Codable>(key: String) -> T? {
        guard !UserDefaultsService.standard.disableCaching else {
            print("caching disabled")
            return nil
        }
        return try? DataCache.instance.readCodable(forKey: key)
    }
    
    enum CachingKeys {
        case actors
        case directors
        case project(id: String)
        case otherProject(id: String)
        
        func getString() -> String {
            switch self {
            case .actors: return "actors"
            case .directors: return "directors"
            case .project(let id): return "project#\(id)"
            case .otherProject(let id): return "other#\(id)"
            }
        }
    }
}
