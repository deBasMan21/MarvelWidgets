//
//  RelatedProject.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct RelatedProject: Codable {
    let title: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case releaseDate = "ReleaseDate"
    }
}
