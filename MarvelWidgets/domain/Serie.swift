//
//  Serie.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

// MARK: - Welcome
struct SeriesList: Codable {
    let data: [Serie]
    let total: Int
}

// MARK: - Datum
struct Serie: Codable, Identifiable, Project {
    typealias A = UUID
    let id: UUID = UUID()
    let projectId: Int
    let title: String
    let releaseDate, lastAiredDate: String?
    let numberSeasons, numberEpisodes: Int
    let overview: String?
    let coverURL: String
    let trailerURL: String?
    let directedBy: String?
    let phase: Int
    let saga: Saga?
    let imdbID: String

    enum CodingKeys: String, CodingKey {
        case projectId = "id"
        case title
        case releaseDate = "release_date"
        case lastAiredDate = "last_aired_date"
        case numberSeasons = "number_seasons"
        case numberEpisodes = "number_episodes"
        case overview
        case coverURL = "cover_url"
        case trailerURL = "trailer_url"
        case directedBy = "directed_by"
        case phase, saga
        case imdbID = "imdb_id"
    }
    
    func getUniqueProjectId() -> String {
        return "s\(projectId)"
    }
    
    func toData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
