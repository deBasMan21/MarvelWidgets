//
//  NewsService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 21/01/2024.
//

import Foundation

class NewsService: Service {
    static func getNewsItems(page: Int) async -> [NewsItemWrapper] {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .newsItems)
            .addPopulate(type: .populateNormal)
            .addSortByPublishDate()
            .addPagination(pageSize: 10, page: page)
            .getString()
        
        do {
            let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: NewsItemsWrapper.self, auth: config.apiKey)
            
            return result?.data ?? []
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getNewsItemById(id: Int) async -> NewsItemWrapper? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .newsItems)
            .addId(id: "\(id)")
            .addPopulate(type: .populateNormal)
            .getString()
        
        do {
            let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: SingleNewsItemWrapper.self, auth: config.apiKey)
            
            return result?.data
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
    
    static func getNewsItemsWithFilterAndSortKey(filterAndSortKey: String, limitItems: Int) async -> [NewsItemWrapper]? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .newsItems)
            .addCustomFilterAndSortKey(key: filterAndSortKey)
            .addPagination(pageSize: limitItems, page: 1)
            .getString()
        
        let result: NewsItemsWrapper? = await getPrivate(url: url, force: true, cachingKey: .none)
        return result?.data
    }
}
