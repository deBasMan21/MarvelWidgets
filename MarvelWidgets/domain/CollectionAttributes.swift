//
//  CollectionAttributes.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 17/07/2023.
//

import Foundation

struct CollectionAttributes: Codable {
    let name: String
    let backdropUrl: String
    let overview: String
    let projects: RelatedProjects?
    
    enum CodingKeys: String, CodingKey {
        case name, overview, projects
        case backdropUrl = "backdrop_url"
    }
    
    func getBackdropUrl(size: ImageSize = ImageSize(size: .backdrop(.original))) -> String {
        return backdropUrl.replaceUrlPlaceholders(imageSize: size)
    }
}
