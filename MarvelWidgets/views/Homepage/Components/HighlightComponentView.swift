//
//  HighlightComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 23/01/2024.
//

import Foundation
import SwiftUI
import Kingfisher

struct HighlightComponentView: View {
    @State var highlightComponent: HighlightComponent
    @State var entity: (any HomepageEntity)?
    @State var error: Bool = false
    
    var body: some View {
        VStack {
            if let entity {
                CollectionsView(
                    imageUrl: entity.getBackdropUrl(),
                    titleText: highlightComponent.title ?? entity.getTitle(),
                    subTitleText: highlightComponent.subtitle ?? entity.getSubtitle(),
                    inSheet: false,
                    destinationView: entity.getDestinationView()
                )
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
        switch highlightComponent.contentType {
        case .projects:
            if let proj = await ProjectService.getById(highlightComponent.contentTypeId) {
                entity = HomepageProjectEntity(project: proj)
            }
            
        case .actors:
            if let actor = await ActorService.getActorById(id: highlightComponent.contentTypeId) {
                entity = ActorProjectEntity(actor: actor)
            }
            
        case .directors:
            if let director = await DirectorService.getDirectorById(id: highlightComponent.contentTypeId) {
                entity = DirectorProjectEntity(director: director)
            }
            
        case .collections:
            if let collection = await CollectionService.getCollectionById(id: highlightComponent.contentTypeId) {
                entity = CollectionProjectEntity(collection: collection)
            }
            
        case .newsItems:
            if let newsItem = await NewsService.getNewsItemById(id: highlightComponent.contentTypeId) {
                entity = NewsItemProjectEntity(newsItem: newsItem)
            }
        }
        
        if entity == nil {
            error = true
        }
    }
}
