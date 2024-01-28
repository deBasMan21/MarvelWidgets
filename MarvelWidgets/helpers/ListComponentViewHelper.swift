//
//  ListComponentViewHelper.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation

class ListComponentViewHelper {
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
            
        case .page:
            if let pages = await PageService.getPages(filterAndSortKey: filterAndSortKey, limitItems: numberOfItems) {
                return pages.compactMap { CustomPageProjectEntity(customPage: $0) }
            }
        }
        
        return nil
    }
    
    static func fetchSingleContentType(contentType: CMSContentType, contentTypeId: Int) async -> (any HomepageEntity)? {
        switch contentType {
        case .projects:
            if let proj = await ProjectService.getById(contentTypeId) {
                return HomepageProjectEntity(project: proj)
            }
            
        case .actors:
            if let actor = await ActorService.getActorById(id: contentTypeId) {
                return ActorProjectEntity(actor: actor)
            }
            
        case .directors:
            if let director = await DirectorService.getDirectorById(id: contentTypeId) {
                return DirectorProjectEntity(director: director)
            }
            
        case .collections:
            if let collection = await CollectionService.getCollectionById(id: contentTypeId) {
                return CollectionProjectEntity(collection: collection)
            }
            
        case .newsItems:
            if let newsItem = await NewsService.getNewsItemById(id: contentTypeId) {
                return NewsItemProjectEntity(newsItem: newsItem)
            }
            
        case .page:
            if let page = await PageService.getPageById(id: contentTypeId) {
                return CustomPageProjectEntity(customPage: page)
            }
        }
        
        return nil
    }
}
