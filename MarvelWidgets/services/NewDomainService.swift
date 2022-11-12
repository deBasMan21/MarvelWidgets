//
//  NewDomainService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/11/2022.
//

import Foundation

class NewDomainService {
    private static let moviesChronologicallyUrl = "https://serverbuijsen.nl/api/mcu-projects?populate=deep&filters[type][$eq]=Movie"
    
    static func getNewDomainMovies() async -> [ProjectWrapper] {
        do {
            LogService.log("Used api call", in: self)
            let result = try await APIService.apiCall(url: moviesChronologicallyUrl, body: nil, method: "GET", as: ResponseWrapper.self, useAuth: true)
            CachingService.saveToLocalStorage(result, forKey: UserDefaultValues.cachedMovies)
            return result?.data ?? []
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
}
