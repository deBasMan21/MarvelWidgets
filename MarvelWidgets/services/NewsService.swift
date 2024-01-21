//
//  NewsService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 21/01/2024.
//

import Foundation

class NewsService {
    static var config: Config {
        if UserDefaultsService.standard.useConfig,
            !UserDefaultsService.standard.token.isEmpty,
            !UserDefaultsService.standard.baseUrl.isEmpty {
            return DebugConfig.standard
        } else {
            return ProductionConfig.standard
        }
    }
}

extension NewsService {
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
}
