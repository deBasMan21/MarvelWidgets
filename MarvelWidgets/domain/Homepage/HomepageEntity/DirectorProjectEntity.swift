//
//  DirectorProjectEntity.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI

class DirectorProjectEntity: HomepageEntity {
    var id: String
    private let director: DirectorsWrapper
    
    init(director: DirectorsWrapper) {
        self.director = director
        self.id = "director-\(director.id)"
    }
    
    func getTitle() -> String {
        director.attributes.firstName + " " + director.attributes.lastName
    }
    
    func getSubtitle() -> String? {
        director.attributes.dateOfBirth
    }
    
    func getMultilineDescription() -> String {
        "Birthdate: \(director.attributes.dateOfBirth?.toDate()?.toFormattedString() ?? "Unkown")"
    }
    
    func getImageUrl() -> String {
        director.attributes.imageURL?.replaceUrlPlaceholders(imageSize: ImageSize(size: .poster(.original))) ?? ""
    }
    
    func getDestinationUrl() -> String {
        InternalUrlBuilder.createUrl(entity: .director, id: director.id, homepage: true)
    }
}
