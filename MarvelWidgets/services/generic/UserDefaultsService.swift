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
        static let showOtherTabsKey = "showOtherTabs"
        static let showNewsTabKey = "showNewsTab"
        static let showActorsAndDirectorsKey = "showActorsAndDirectors"
        static let disableCaching = "disableCaching"
    }
    
    var subscribeTopics: [String] {
        get {
            defs.array(forKey: UserDefaultsKeys.topicsKey) as? [String] ?? []
        }
        set(value) {
            defs.set(value, forKey: UserDefaultsKeys.topicsKey)
        }
    }
    
    var showOtherTabs: Bool {
        get {
            defs.bool(forKey: UserDefaultsKeys.showOtherTabsKey)
        }
    }
    
    var disableCaching: Bool {
        get {
            defs.bool(forKey: UserDefaultsKeys.disableCaching)
        }
    }
}
