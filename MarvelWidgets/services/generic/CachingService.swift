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
        return try? DataCache.instance.readCodable(forKey: key)
    }
}
