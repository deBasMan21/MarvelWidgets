//
//  Config.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 05/04/2023.
//

import Foundation

protocol Config {
    static var standard: Config { get }
    
    var baseUrl: String { get }
    var apiKey: String { get }
    var trackingUrl: String { get }
}
