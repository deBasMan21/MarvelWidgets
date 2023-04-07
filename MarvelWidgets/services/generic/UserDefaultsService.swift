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
        static let seenOnboarding = "seenOnboarding"
        static let alwaysShowOnboarding = "alwaysShowOnboarding"
        static let baseUrl = "baseUrl"
        static let token = "token"
        static let useConfig = "useConfig"
        static let previousTabbarHeight = "previousTabbarHeight"
    }
    
    var useConfig: Bool {
        get {
            defs.bool(forKey: UserDefaultsKeys.useConfig)
        }
    }
    
    var baseUrl: String {
        get {
            defs.string(forKey: UserDefaultsKeys.baseUrl) ?? ""
        }
    }
    
    var token: String {
        get {
            defs.string(forKey: UserDefaultsKeys.token) ?? ""
        }
    }
    
    var subscribeTopics: [String] {
        get {
            defs.array(forKey: UserDefaultsKeys.topicsKey) as? [String] ?? []
        }
        set(value) {
            defs.set(value, forKey: UserDefaultsKeys.topicsKey)
        }
    }
    
    var disableCaching: Bool {
        get {
            defs.bool(forKey: UserDefaultsKeys.disableCaching)
        }
    }
    
    var seenOnboarding: Bool {
        get {
            defs.bool(forKey: UserDefaultsKeys.seenOnboarding)
        }
        set(value) {
            defs.set(value, forKey: UserDefaultsKeys.seenOnboarding)
        }
    }
    
    var alwaysShowOnboarding: Bool {
        get {
            defs.bool(forKey: UserDefaultsKeys.alwaysShowOnboarding)
        }
    }
    
    var previousTabbarHeight: Int {
        get {
            defs.integer(forKey: UserDefaultsKeys.previousTabbarHeight)
        }
        set(value) {
            defs.set(value, forKey: UserDefaultsKeys.previousTabbarHeight)
        }
    }
}
