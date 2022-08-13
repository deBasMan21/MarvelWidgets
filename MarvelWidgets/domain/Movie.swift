//
//  Movie.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

// MARK: - Welcome
struct MovieList: Codable {
    let data: [Movie]
    let total: Int
}

// MARK: - Datum
struct Movie: Codable, Identifiable, Project {
    typealias A = UUID
    let id: UUID = UUID()
    let projectId: Int
    let title, boxOffice: String
    let releaseDate: String?
    let duration: Int
    let overview: String?
    let coverURL: String
    let trailerURL: String?
    let directedBy: String?
    let phase: Int
    let saga: Saga?
    let chronology, postCreditScenes: Int
    let imdbID: String
    let relatedMovies: [Movie]?

    enum CodingKeys: String, CodingKey {
        case projectId = "id"
        case title
        case releaseDate = "release_date"
        case boxOffice = "box_office"
        case duration, overview
        case coverURL = "cover_url"
        case trailerURL = "trailer_url"
        case directedBy = "directed_by"
        case phase, saga, chronology
        case postCreditScenes = "post_credit_scenes"
        case imdbID = "imdb_id"
        case relatedMovies = "related_movies"
    }
    
    func getUniqueProjectId() -> String {
        return "m\(projectId)"
    }
    
    func toData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
