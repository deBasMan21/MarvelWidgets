//
//  VerticalListComponent.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation

struct VerticalListComponent: Codable, Hashable {
    let id: Int
    let title: String?
    let openMoreLink: Bool
    let numberOfItems: Int
    let contentType: CMSContentType
    let filterAndSortKey: String?
}
