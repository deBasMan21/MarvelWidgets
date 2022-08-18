//
//  SeriesService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

class SeriesService {
    private static let moviesChronologicallyUrl = "https://mcuapi.herokuapp.com/api/v1/tvshows?order=release_date%2CDESC"
    private static let moviesByIdUrl = "https://mcuapi.herokuapp.com/api/v1/tvshows/"
    
    static func getSeriesChronologically() async -> [Serie] {
        do {
            let result = try await APIService.apiCall(url: moviesChronologicallyUrl, body: nil, method: "GET", as: SeriesList.self)
            return result?.data ?? []
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getSerieById(_ id: Int) async -> Serie? {
        do {
            LogService.log("Used api call for detail page", in: self)
            let result = try await APIService.apiCall(url: "\(moviesByIdUrl)\(id)", body: nil, method: "GET", as: Serie.self)
            return result
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
}
