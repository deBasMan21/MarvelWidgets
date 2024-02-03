//
//  NewsListPageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 21/01/2024.
//

import Foundation
import SwiftUI
import Kingfisher

struct NewsListPageView: View {
    @State var newsItems: [NewsItemWrapper] = []
    @State var previousViewOffset: CGFloat = 0
    @State var page: Int = 1
    let totalPages: Int = 3
    let minimumOffset: CGFloat = 450
    
    var body: some View {
        VStack {
            Text("Provided by 'The Direct'")
                .font(.caption)
                .bold()
            
            ScrollView {
                LazyVStack {
                    ForEach(newsItems) { item in
                        NavigationLink(
                            destination: {
                                NewsItemDetailView(newsItem: item)
                            }
                        ) {
                            NewsItemView(
                                item: HeaderWidgetComponent(
                                    id: item.id,
                                    imageUrl: item.attributes.imageUrl,
                                    title: item.attributes.title,
                                    categories: item.attributes.categories?.compactMap { HeaderWidgetCategory(category: $0.category) },
                                    gridItems: [
                                        HeaderWidgetGridItem(
                                            iconName: "calendar.circle.fill",
                                            title: "Releasedate",
                                            value: item.attributes.date_published.toDateFromDateTime()?.toFormattedString() ?? ""
                                        ),
                                        HeaderWidgetGridItem(
                                            iconName: "person.circle.fill",
                                            title: "Author",
                                            value: item.attributes.author
                                        )
                                    ],
                                    description: item.attributes.summary,
                                    contentType: nil,
                                    contentTypeId: nil,
                                    showImage: true,
                                    largeTitleAndGrid: false
                                ),
                                appearingAnimation: true,
                                whiteText: false,
                                height: minimumOffset
                            ).onAppear {
                                guard let thresholdIndex = newsItems.last?.id else { return }
                                guard thresholdIndex == item.id else { return }
                                guard page < totalPages else { return }
                                
                                page += 1
                                Task {
                                    newsItems.append(contentsOf: await NewsService.getNewsItems(page: page))
                                }
                            }.foregroundStyle(.white)
                        }
                    }
                }.scrollTargetLayout()
            }.scrollTargetBehavior(.viewAligned(limitBehavior: .always))
                .defaultScrollAnchor(.topLeading)
                .scrollIndicators(.hidden)
                .refreshable {
                    page = 1
                    newsItems = await NewsService.getNewsItems(page: page)
                }
        }.navigationTitle("MCU News")
            .task {
                self.newsItems = await NewsService.getNewsItems(page: page)
            }
            .toolbar(content: {
                NavigationLink(
                    destination: WidgetSettingsView()
                ) {
                    Image(systemName: "gearshape.fill")
                }
            }).showTabBar()
    }
}
