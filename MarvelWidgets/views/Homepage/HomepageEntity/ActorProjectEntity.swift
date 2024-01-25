//
//  ActorProjectEntity.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI

class ActorProjectEntity: HomepageEntity {
    var id: String
    private let actor: ActorsWrapper
    
    init(actor: ActorsWrapper) {
        self.actor = actor
        self.id = "actor-\(actor.id)"
    }
    
    func getTitle() -> String {
        actor.attributes.firstName + " " + actor.attributes.lastName
    }
    
    func getSubtitle() -> String? {
        actor.attributes.character
    }
    
    func getMultilineDescription() -> String {
        "Birthdate: \(actor.attributes.dateOfBirth?.toDate()?.toFormattedString() ?? "Unkown")\nCharacter: \(actor.attributes.character)"
    }
    
    func getImageUrl() -> String {
        actor.attributes.imageURL?.replaceUrlPlaceholders(imageSize: ImageSize(size: .poster(.original))) ?? ""
    }
    
    func getDestinationView() -> any View {
        PersonDetailView(person: actor.person)
    }
}
