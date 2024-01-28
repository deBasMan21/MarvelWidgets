//
//  PageService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/01/2024.
//

import Foundation

class PageService: Service {
    static func getPageById(id: Int) async -> CustomPageWrapper? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .page)
            .addId(id: "\(id)")
            .addPopulate(type: .populateDeep(level: 3))
            .getString()
        
        do {
            let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: CustomPagesWrapper.self, auth: config.apiKey)
            
            return result?.data
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
    
    static func getPages(filterAndSortKey: String, limitItems: Int) async -> [CustomPageWrapper]? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .page)
            .addCustomFilterAndSortKey(key: filterAndSortKey)
            .addPagination(pageSize: limitItems, page: 1)
            .getString()
        
        do {
            let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: CustomPagesListWrapper.self, auth: config.apiKey)
            
            return result?.data
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
    
    static func getHomepage() async -> HomepageWrapper? {
        let url = UrlBuilder(baseUrl: config.baseUrl, entity: .homePage)
            .addPopulate(type: .populateDeep(level: 3))
            .getString()
        
        do {
            let result = try await APIService.apiCall(url: url, body: nil, method: "GET", as: HomepagesWrapper.self, auth: config.apiKey)
            
            return result?.data
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
}
