//
//  HeaderWidgetComponent.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 25/01/2024.
//

import Foundation

struct HeaderWidgetComponent: Codable, Hashable {
    let id: Int
    let imageUrl: String
    let title: String
    let categories: [HeaderWidgetCategory]?
    let gridItems: [HeaderWidgetGridItem]?
    let description: String?
    let contentType: CMSContentType?
    let contentTypeId: Int?
    let showImage: Bool
    let largeTitleAndGrid: Bool
}

struct HeaderWidgetCategory: Codable, Hashable {
    let category: String
}

struct HeaderWidgetGridItem: Codable, Hashable {
    let iconName: String
    let title: String
    let value: String
}
