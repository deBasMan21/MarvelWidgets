//
//  Poster.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct Poster: Codable, Identifiable, Equatable {
    let id: Int
    let posterURL: String
 
    enum CodingKeys: String, CodingKey {
        case id
        case posterURL = "PosterUrl"
    }
}
