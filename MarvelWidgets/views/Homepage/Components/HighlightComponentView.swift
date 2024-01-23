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
                    imageUrl: entity.getImageUrl(),
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
            if let actor = await ProjectService.getActorById(id: highlightComponent.contentTypeId) {
                entity = ActorProjectEntity(actor: actor)
            }
            
        case .directors:
            if let director = await ProjectService.getDirectorById(id: highlightComponent.contentTypeId) {
                entity = DirectorProjectEntity(director: director)
            }
            
        case .collections:
            if let collection = await ProjectService.getCollectionById(id: highlightComponent.contentTypeId) {
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

protocol HomepageEntity {
    func getTitle() -> String
    func getSubtitle() -> String?
    func getImageUrl() -> String
    func getDestinationView() -> any View
}

class HomepageProjectEntity: HomepageEntity {
    private let project: ProjectWrapper
    
    init(project: ProjectWrapper) {
        self.project = project
    }
    
    func getTitle() -> String {
        project.attributes.title
    }
    
    func getSubtitle() -> String? {
        project.attributes.releaseDate
    }
    
    func getImageUrl() -> String {
        project.attributes.getPosterUrls().first ?? ""
    }
    
    func getDestinationView() -> any View {
        ProjectDetailView(viewModel: ProjectDetailViewModel(project: self.project), inSheet: false)
    }
}

class ActorProjectEntity: HomepageEntity {
    private let actor: ActorsWrapper
    
    init(actor: ActorsWrapper) {
        self.actor = actor
    }
    
    func getTitle() -> String {
        actor.attributes.firstName + " " + actor.attributes.lastName
    }
    
    func getSubtitle() -> String? {
        actor.attributes.character
    }
    
    func getImageUrl() -> String {
        actor.attributes.imageURL?.replaceUrlPlaceholders(imageSize: ImageSize(size: .poster(.original))) ?? ""
    }
    
    func getDestinationView() -> any View {
        PersonDetailView(person: actor.person)
    }
}

class DirectorProjectEntity: HomepageEntity {
    private let director: DirectorsWrapper
    
    init(director: DirectorsWrapper) {
        self.director = director
    }
    
    func getTitle() -> String {
        director.attributes.firstName + " " + director.attributes.lastName
    }
    
    func getSubtitle() -> String? {
        director.attributes.dateOfBirth
    }
    
    func getImageUrl() -> String {
        director.attributes.imageURL?.replaceUrlPlaceholders(imageSize: ImageSize(size: .poster(.original))) ?? ""
    }
    
    func getDestinationView() -> any View {
        PersonDetailView(person: director.person)
    }
}

class CollectionProjectEntity: HomepageEntity {
    private let collection: ProjectCollection
    
    init(collection: ProjectCollection) {
        self.collection = collection
    }
    
    func getTitle() -> String {
        collection.attributes.name
    }
    
    func getSubtitle() -> String? {
        nil
    }
    
    func getImageUrl() -> String {
        collection.attributes.backdropUrl.replaceUrlPlaceholders(imageSize: ImageSize(size: .poster(.original)))
    }
    
    func getDestinationView() -> any View {
        CollectionPageView(collection: collection, inSheet: false)
    }
}

class NewsItemProjectEntity: HomepageEntity {
    private let newsItem: NewsItemWrapper
    
    init(newsItem: NewsItemWrapper) {
        self.newsItem = newsItem
    }
    
    func getTitle() -> String {
        newsItem.attributes.title
    }
    
    func getSubtitle() -> String? {
        newsItem.attributes.summary
    }
    
    func getImageUrl() -> String {
        newsItem.attributes.imageUrl.replaceUrlPlaceholders(imageSize: ImageSize(size: .poster(.original)))
    }
    
    func getDestinationView() -> any View {
        WebView(webView: WebViewModel(url: newsItem.attributes.url).webView)
    }
}
