//
//  DebugConfig.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 05/04/2023.
//

import Foundation

class DebugConfig: Config {
    var baseUrl: String {
        UserDefaultsService.standard.baseUrl
    }
    var apiKey: String {
        UserDefaultsService.standard.token
    }
    
    init() { }
}
