//
//  HeaderWidgetComponent.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 25/01/2024.
//

import Foundation

struct HeaderWidgetComponent: Codable {
    let id: Int
    let imageUrl: String
    let title: String
    let categories: [HeaderWidgetCategory]?
    let gridItems: [HeaderWidgetGridItem]?
    let description: String?
    let contentType: CMSContentType?
    let contentTypeId: Int?
}

struct HeaderWidgetCategory: Codable {
    let category: String
}

struct HeaderWidgetGridItem: Codable {
    let iconName: String
    let title: String
    let value: String
}
