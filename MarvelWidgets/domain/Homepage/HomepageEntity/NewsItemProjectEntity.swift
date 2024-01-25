//
//  NewsItemProjectEntity.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI

class NewsItemProjectEntity: HomepageEntity {
    var id: String
    private let newsItem: NewsItemWrapper
    
    init(newsItem: NewsItemWrapper) {
        self.newsItem = newsItem
        self.id = "newsItem-\(newsItem.id)"
    }
    
    func getTitle() -> String {
        newsItem.attributes.title
    }
    
    func getSubtitle() -> String? {
        newsItem.attributes.date_published.toDateFromDateTime()?.toFormattedString()
    }
    
    func getMultilineDescription() -> String {
        "\(newsItem.attributes.date_published.toDateFromDateTime()?.toFormattedString() ?? "")\nWritten by: \(newsItem.attributes.author)"
    }
    
    func getImageUrl() -> String {
        newsItem.attributes.imageUrl.replaceUrlPlaceholders(imageSize: ImageSize(size: .poster(.original)))
    }
    
    func getDestinationView() -> any View {
        WebView(webView: WebViewModel(url: newsItem.attributes.url).webView)
            .navigationTitle(newsItem.attributes.title)
    }
}
