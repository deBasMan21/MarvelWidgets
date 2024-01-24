//
//  HomepageService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/01/2024.
//

import Foundation

class HomepageService: Service {
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
