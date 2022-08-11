//
//  MovieService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

class MovieService {
    private static let moviesChronologicallyUrl = "https://mcuapi.herokuapp.com/api/v1/movies?order=release_date%2CDESC"
    private static let moviesByIdUrl = "https://mcuapi.herokuapp.com/api/v1/movies/"
    
    static func getMoviesChronologically() async -> [Movie] {
        if CachingService.hasRecentVersionInCache(forKey: UserDefaultValues.cachedMovies) {
            LogService.log("Used cache", in: self)
            let values = CachingService.getFromLocalStorage([Movie].self, forKey: UserDefaultValues.cachedMovies)
            if let values = values {
                return values
            }
        }
        
        do {
            LogService.log("Used api call", in: self)
            let result = try await APIService.apiCall(url: moviesChronologicallyUrl, body: nil, method: "GET", as: MovieList.self)
            CachingService.saveToLocalStorage(result, forKey: UserDefaultValues.cachedMovies)
            return result?.data ?? []
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return []
        }
    }
    
    static func getMovieById(_ id: Int) async -> Movie? {
        do {
            LogService.log("Used api call for detail page", in: self)
            let result = try await APIService.apiCall(url: "\(moviesByIdUrl)\(id)", body: nil, method: "GET", as: Movie.self)
            return result
        } catch let error {
            LogService.log(error.localizedDescription, in: self)
            return nil
        }
    }
}
