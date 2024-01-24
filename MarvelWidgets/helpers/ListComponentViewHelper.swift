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
        }
        
        return nil
    }
}
