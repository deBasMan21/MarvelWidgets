//
//  MoviesViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

extension MoviesView {
    class MoviesViewModel: ObservableObject {
        @Published var movies: [Movie] = []
        @Published var orderType: OrderType = .releaseDate
        
        func fetchMovies() async {
            _ = await MainActor.run {
                Task {
                    movies = await MovieService.getMoviesChronologically()
                }
            }
        }
        
        func orderMovies(by orderType: OrderType) {
            self.orderType = orderType
            switch orderType {
            case .nameASC:
                movies = movies.sorted(by: { $0.title < $1.title})
            case .nameDESC:
                movies = movies.sorted(by: { $0.title > $1.title})
            case .releaseDate:
                movies = movies.sorted(by: { $0.releaseDate ?? "" > $1.releaseDate ?? ""})
            case .chronological:
                movies = movies.sorted(by: { $0.chronology > $1.chronology})
            case .duration:
                movies = movies.sorted(by: { $0.duration > $1.duration})
            case .boxOffice:
                movies = movies.sorted(by: { $0.boxOffice > $1.boxOffice})
            }
        }
        
        func refresh() async {
            await fetchMovies()
            orderMovies(by: orderType)
        }
    }
    
    enum OrderType: String, CaseIterable {
        case nameASC = "Naam A-Z"
        case nameDESC = "Naam Z-A"
        case releaseDate = "Release datum"
        case chronological = "Chronologisch"
        case duration = "Filmduur"
        case boxOffice = "Box office"
    }
}
