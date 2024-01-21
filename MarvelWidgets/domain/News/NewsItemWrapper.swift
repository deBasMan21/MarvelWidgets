//
//  NewsItemWrapper.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 21/01/2024.
//

import Foundation

struct NewsItemWrapper: Identifiable, Codable {
    let id: Int
    let attributes: NewsItem
}
