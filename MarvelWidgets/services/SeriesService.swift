//
//  SeriesService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

class SeriesService {
    private static let moviesChronologicallyUrl = "https://mcuapi.herokuapp.com/api/v1/tvshows?order=release_date%2CDESC"
    
    static func getSeriesChronologically() async -> [Serie] {
        do {
            let result = try await APIService.apiCall(url: moviesChronologicallyUrl, body: nil, method: "GET", obj: SeriesList(data: [], total: 0))
            return result?.data ?? []
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
}
