//
//  HomePageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 23/01/2024.
//

import Foundation
import SwiftUI
import Kingfisher

struct HomePageView: View {
    @State var homepage: HomepageWrapper?
    
    var body: some View {
        VStack {
            if let homepage {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(homepage.attributes.components) { component in
                            switch component {
                            case .highlight(let component): HighlightComponentView(highlightComponent: component)
                            case .text(let component): TextComponentView(textComponent: component)
                            case .youtube(let component): YoutubeComponentView(title: component.title, url: component.embedUrl)
                            case .title(let component): TitleComponentView(component: component)
                            case .horizontalList(let component): HorizontalListComponentView(component: component)
                            default: EmptyView()
                            }
                        }
                    }.padding(.horizontal, 20)
                }
            } else {
                ProgressView()
            }
        }.task {
            homepage = await HomepageService.getHomepage()
        }.refreshable {
            homepage = await HomepageService.getHomepage()
        }.showTabBar()
            .navigationTitle("Home")
    }
}

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
            await fetchContentType()
        }
    }
    
    func fetchContentType() async {
        switch component.contentType {
        case .projects:
            if let projects = await ProjectService.getAllWithFilterAndSortKey(filterAndSortKey: component.filterAndSortKey, limitItems: component.numberOfItems) {
                entities = projects.compactMap { HomepageProjectEntity(project: $0) }
            }
            
        case .actors:
            if let actors = await ProjectService.getActorsWithFilterAndSortKey(filterAndSortKey: component.filterAndSortKey, limitItems: component.numberOfItems) {
                entities = actors.compactMap { ActorProjectEntity(actor: $0) }
            }
            
        case .directors:
            if let directors = await ProjectService.getDirectorsWithFilterAndSortKey(filterAndSortKey: component.filterAndSortKey, limitItems: component.numberOfItems) {
                entities = directors.compactMap { DirectorProjectEntity(director: $0) }
            }
//            
//        case .collections:
//            if let collection = await ProjectService.getCollectionById(id: highlightComponent.contentTypeId) {
//                entity = CollectionProjectEntity(collection: collection)
//            }
//            
//        case .newsItems:
//            if let newsItem = await NewsService.getNewsItemById(id: highlightComponent.contentTypeId) {
//                entity = NewsItemProjectEntity(newsItem: newsItem)
//            }
            
        default: break
        }
        
        if entities == nil {
            error = true
        }
    }
}

struct LabelIconStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}
