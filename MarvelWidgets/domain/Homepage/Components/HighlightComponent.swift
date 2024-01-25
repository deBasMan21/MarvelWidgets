//
//  HighlightComponent.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/01/2024.
//

import Foundation

struct HighlightComponent: Codable {
    let id: Int
    let contentType: CMSContentType
    let contentTypeId: Int
    let title: String?
    let subtitle: String?
}

enum CMSContentType: String, Codable {
    case projects = "mcu-projects"
    case actors = "actors"
    case directors = "directors"
    case collections = "collections"
    case newsItems = "news-items"
}
