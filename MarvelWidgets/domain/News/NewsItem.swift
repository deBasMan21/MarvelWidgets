//
//  NewsItem.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 21/01/2024.
//

import Foundation

struct NewsItem: Codable {
    let guid: String
    let url: String
    let title: String
    let summary: String
    let date_published: String
    let author: String
    let content: String
    let categories: [NewsCategory]?
    let image: NewsImage?
}
