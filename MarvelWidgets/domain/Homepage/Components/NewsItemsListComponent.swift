//
//  NewsItemsListComponent.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/01/2024.
//

import Foundation

struct NewsItemsListComponent: Codable {
    let title: String
    let amountOfItems: Int
    let newsItems: NewsItemsWrapper
}
