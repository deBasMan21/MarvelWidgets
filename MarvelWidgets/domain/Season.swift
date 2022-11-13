//
//  Season.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct Season: Codable, Identifiable, Equatable {
    let uuid = UUID()
    let id: Int
    let seasonNumber: Int
    let numberOfEpisodes: Int?
    let episodes: [Episode]?
    let seasonTrailers: [Trailer]?
    let posters: [Poster]?
 
    enum CodingKeys: String, CodingKey {
        case id
        case seasonNumber = "SeasonNumber"
        case numberOfEpisodes = "NumberOfEpisodes"
        case episodes = "Episodes"
        case seasonTrailers = "SeasonTrailers"
        case posters = "Posters"
    }
}
