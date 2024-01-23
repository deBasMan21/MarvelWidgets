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
    let contentType: String
    let filterAndSortKey: String
}
