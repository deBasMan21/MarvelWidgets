//
//  HorizontalListComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI

struct HorizontalListComponentView: View {
    @State var component: HorizontalListComponent
    @State var entities: [any HomepageEntity]? = nil
    @State var error: Bool = false
    
    var body: some View {
        VStack {
            if let entities {
                VStack {
                    if let title = component.title {
                        Text(title)
                            .font(.title)
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(entities, id: \.id) { entity in
                                NavigationLink(
                                    destination: AnyView(entity.getDestinationView())
                                ) {
                                    PosterListViewItem(
                                        posterUrl: entity.getImageUrl(),
                                        title: entity.getTitle(),
                                        subTitle: entity.getSubtitle(),
                                        showGradient: true
                                    )
                                }.id(entity.id)
                            }
                        }
                    }.scrollClipDisabled()
                        .scrollIndicators(.hidden)
                    
                    if component.openMoreLink {
                        HStack {
                            Spacer()
                            
                            NavigationLink(destination: Text("Whole list"), label: {
                                Label("More", systemImage: "chevron.right")
                                    .labelStyle(LabelIconStyle())
                            })
                        }.padding(.top, 10)
                    }
                }
            } else if error {
                EmptyView()
            } else {
                ProgressView()
            }
        }.task {
            if let result = await ListComponentView.fetchContentType(
                contentType: component.contentType,
                filterAndSortKey: component.filterAndSortKey ?? "",
                numberOfItems: component.numberOfItems
            ) {
                entities = result
            } else {
                error = true
            }
        }
    }
    
    
}

class ListComponentView {
    static func fetchContentType(contentType: CMSContentType, filterAndSortKey: String, numberOfItems: Int) async -> [any HomepageEntity]? {
        switch contentType {
        case .projects:
            if let projects = await ProjectService.getAllWithFilterAndSortKey(filterAndSortKey: filterAndSortKey, limitItems: numberOfItems) {
                return projects.compactMap { HomepageProjectEntity(project: $0) }
            }
            
        case .actors:
            if let actors = await ActorService.getActorsWithFilterAndSortKey(filterAndSortKey: filterAndSortKey, limitItems: numberOfItems) {
                return actors.compactMap { ActorProjectEntity(actor: $0) }
            }
            
        case .directors:
            if let directors = await DirectorService.getDirectorsWithFilterAndSortKey(filterAndSortKey: filterAndSortKey, limitItems: numberOfItems) {
                return directors.compactMap { DirectorProjectEntity(director: $0) }
            }
            
        case .collections:
            if let collections = await CollectionService.getCollectionsWithFilterAndSortKey(filterAndSortKey: filterAndSortKey, limitItems: numberOfItems) {
                return collections.compactMap { CollectionProjectEntity(collection: $0) }
            }
            
        case .newsItems:
            if let newsItems = await NewsService.getNewsItemsWithFilterAndSortKey(filterAndSortKey: filterAndSortKey, limitItems: numberOfItems) {
                return newsItems.compactMap { NewsItemProjectEntity(newsItem: $0) }
            }
        }
        
        return nil
    }
}
