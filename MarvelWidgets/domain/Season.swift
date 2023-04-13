//
//  Season.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct Season: Codable, Identifiable, Equatable {
    static func == (lhs: Season, rhs: Season) -> Bool {
        lhs.id == rhs.id
    }
    
    let uuid = UUID()
    let id: Int
    let seasonNumber: Int
    let numberOfEpisodes: Int?
    let seasonProject: SingleResponseWrapper?
    let imageUrl: String?
 
    enum CodingKeys: String, CodingKey {
        case id
        case seasonNumber = "SeasonNumber"
        case numberOfEpisodes = "NumberOfEpisodes"
        case seasonProject, imageUrl
    }
}
