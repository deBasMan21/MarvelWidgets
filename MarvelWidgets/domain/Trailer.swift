//
//  Trailer.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct Trailer: Codable, Identifiable, Equatable {
    let id: Int
    let trailerName: String
    let youtubeLink: String
 
    enum CodingKeys: String, CodingKey {
        case id
        case trailerName = "TrailerName"
        case youtubeLink = "YoutubeLink"
    }
}
