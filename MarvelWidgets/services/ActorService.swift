//
//  ActorService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation

class ActorService: Service {
    static func getActors(force: Bool = false) async -> [ActorsWrapper] {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .actor)
            .getString()
        
        let result: Actors? = await getPrivate(url: url, force: force, cachingKey: .actor)
        return result?.data ?? []
    }
    
    static func getActorById(id: Int, force: Bool = false) async -> ActorsWrapper? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .actor)
            .addId(id: "\(id)")
            .addPopulate(type: .populatePersonPosters)
            .getString()
        
        let result: SingleActor? = await getPrivate(url: url, force: true, cachingKey: .none)
        return result?.data
    }
    
    static func getActorsWithFilterAndSortKey(filterAndSortKey: String, limitItems: Int) async -> [ActorsWrapper]? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .actor)
            .addCustomFilterAndSortKey(key: filterAndSortKey)
            .addPopulate(type: .populatePersonPosters)
            .addPagination(pageSize: limitItems, page: 1)
            .getString()
        
        let result: Actors? = await getPrivate(url: url, force: true, cachingKey: .none)
        return result?.data
    }
}
