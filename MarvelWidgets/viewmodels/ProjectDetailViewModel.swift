//
//  ProjectDetailViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation

extension ProjectDetailView {
    class ProjectDetailViewModel: ObservableObject {
        @Published var movie: Movie?
        
        func getMovieDetails(for id: Int) async {
            _ = await MainActor.run {
                Task {
                    movie = await MovieService.getMovieById(id)
                }
            }
        }
    }
}
