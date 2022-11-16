//
//  UserDefaultsService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 16/11/2022.
//

import Foundation

class UserDefaultsService {
    static let standard = UserDefaultsService()
    
    private var defs = UserDefaults.standard
    private enum UserDefaultsKeys {
        static let topicsKey = "subscribedTopics"
    }
    
    var subscribeTopics: [String] {
        get {
            defs.array(forKey: UserDefaultsKeys.topicsKey) as? [String] ?? []
        }
        set(value) {
            defs.set(value, forKey: UserDefaultsKeys.topicsKey)
        }
    }
}
