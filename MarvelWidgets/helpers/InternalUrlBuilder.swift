//
//  InternalUrlBuilder.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 03/02/2024.
//

import Foundation

class InternalUrlBuilder {
    private static let baseUrl = "https://mcuwidgets.page.link/"
    
    enum Entity: String {
        case project = "project"
        case actor = "actor"
        case director = "director"
        case collection = "collection"
        case news = "news"
        case page = "page"
    }
    
    static func createUrl(entity: Entity, id: Int, homepage: Bool) -> String {
        var url = baseUrl
        if homepage {
            url += "home/"
        }
        url += entity.rawValue
        url += "/\(id)"
        return url
    }
}
