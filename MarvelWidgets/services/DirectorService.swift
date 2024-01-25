//
//  PersonService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/11/2022.
//

import Foundation

class DirectorService: Service {
    static func getDirectors(force: Bool = false) async -> [DirectorsWrapper] {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .director)
            .getString()
        
        let result: Directors? = await getPrivate(url: url, force: force, cachingKey: .director)
        return result?.data ?? []
    }
    
    static func getDirectorById(id: Int, force: Bool = false) async -> DirectorsWrapper? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .director)
            .addId(id: "\(id)")
            .addPopulate(type: .populatePersonPosters)
            .getString()
        
        let result: SignleDirector? = await getPrivate(url: url, force: true, cachingKey: .none)
        return result?.data
    }
    
    static func getDirectorsWithFilterAndSortKey(filterAndSortKey: String, limitItems: Int) async -> [DirectorsWrapper]? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .director)
            .addCustomFilterAndSortKey(key: filterAndSortKey)
            .addPopulate(type: .populatePersonPosters)
            .addPagination(pageSize: limitItems, page: 1)
            .getString()
        
        let result: Directors? = await getPrivate(url: url, force: true, cachingKey: .none)
        return result?.data
    }
}
