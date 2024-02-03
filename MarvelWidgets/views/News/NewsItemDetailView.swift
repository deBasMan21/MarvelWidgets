//
//  NewsItemDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 30/01/2024.
//

import Foundation
import SwiftUI

struct NewsItemDetailView: View {
    @State var newsItem: NewsItemWrapper
    
    var body: some View {
        VStack {
            if !newsItem.attributes.url.isEmpty {
                WebView(
                    webView: WebViewModel(
                        url: newsItem.attributes.url
                    ).webView
                )
            } else {
                LogoLoaderView()
            }
        }.navigationTitle(newsItem.attributes.title)
            .toolbar {
                ShareLink(
                    item: getUrl(),
                    subject: Text(newsItem.attributes.title),
                    message: Text("\"\(newsItem.attributes.title)\" is shared with you! Open with MCUWidgets via: \(getUrl())"),
                    preview: SharePreview(
                        newsItem.attributes.title,
                        image: Image(UIApplication.shared.alternateIconName ?? "AppIcon")
                    )
                )
            }.task {
                guard newsItem.attributes.url.isEmpty else { return }
                if let newsItem = await NewsService.getNewsItemById(id: newsItem.id) {
                    self.newsItem = newsItem
                }
            }
    }
    
    func getUrl() -> String {
        InternalUrlBuilder.createUrl(entity: .news, id: newsItem.id, homepage: false)
    }
}
