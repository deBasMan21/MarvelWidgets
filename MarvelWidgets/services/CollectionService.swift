//
//  CollectionService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation

class CollectionService: Service {
    static func getCollectionById(id: Int) async -> ProjectCollection? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .collection)
            .addId(id: "\(id)")
            .addPopulate(type: .populateCollection)
            .getString()
        
        let result: CollectionWrapper? = await getPrivate(url: url, force: true, cachingKey: .none)
        return result?.data
    }
    
    static func getCollectionsWithFilterAndSortKey(filterAndSortKey: String, limitItems: Int) async -> [ProjectCollection]? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .collection)
            .addCustomFilterAndSortKey(key: filterAndSortKey)
            .addPagination(pageSize: limitItems, page: 1)
            .getString()
        
        let result: CollectionsWrapper? = await getPrivate(url: url, force: true, cachingKey: .none)
        return result?.data
    }
}
