//
//  CachingService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

class CachingService {
    private static let userDefs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
    
    static func saveToLocalStorage<T: Codable>(_ data: T, forKey key: String) {
        let encoder = JSONEncoder()
        let dataObj = try? encoder.encode(data)
        userDefs.set(dataObj, forKey: key)
        userDefs.set(Date.now.description, forKey: "\(key)Date")
        LogService.log("saved to local storage", in: self)
    }
    
    static func getFromLocalStorage<T: Decodable>(_ t: T.Type, forKey key: String) -> T? {
        let data = userDefs.data(forKey: key)
        guard let data = data else {
            return nil
        }
        let decoder = JSONDecoder()
        let values = try? decoder.decode(T.self, from: data)
        return values
    }
    
    static func hasRecentVersionInCache(forKey key: String) -> Bool {
        let lastCache = userDefs.string(forKey: "\(key)Date")
        guard let lastCache = lastCache else {
            return false
        }
        let date = lastCache.toDate()
        if let date = date, date.differenceInDays(from: Date.now.addingTimeInterval(-60 * 60 * 24)) > 1 {
            return true
        } else {
            return false
        }
    }
}
