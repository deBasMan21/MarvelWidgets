//
//  HorizontalListComponent.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/01/2024.
//

import Foundation

struct HorizontalListComponent: Codable {
    let id: Int
    let title: String?
    let openMoreLink: Bool
    let numberOfItems: Int
    let contentType: CMSContentType
    let filterAndSortKey: String?
    let viewType: ViewType
}

enum ViewType: String, Codable {
    case poster = "poster"
    case circle = "circle"
}
