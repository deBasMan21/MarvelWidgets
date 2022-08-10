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
struct Movie: Codable, Identifiable {
    let id: Int
    let title, releaseDate, boxOffice: String
    let duration: Int
    let overview: String?
    let coverURL: String
    let trailerURL: String?
    let directedBy: String
    let phase: Int
    let saga: Saga
    let chronology, postCreditScenes: Int
    let imdbID: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case releaseDate = "release_date"
        case boxOffice = "box_office"
        case duration, overview
        case coverURL = "cover_url"
        case trailerURL = "trailer_url"
        case directedBy = "directed_by"
        case phase, saga, chronology
        case postCreditScenes = "post_credit_scenes"
        case imdbID = "imdb_id"
    }
}

enum Saga: String, Codable {
    case infinitySaga = "Infinity Saga"
    case multiverseSaga = "Multiverse Saga"
}
