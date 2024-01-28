//
//  ActorPerson.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/04/2023.
//

import Foundation

class ActorPerson: Person, Hashable {
    static func == (lhs: ActorPerson, rhs: ActorPerson) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(dateOfBirth)
    }
    
    var id: Int
    var firstName: String
    var lastName: String
    var role: String
    var dateOfBirth: String?
    var projects: [ProjectWrapper]
    var imageUrl: URL?
    
    private var actor: ActorsWrapper
    
    init(_ actor: ActorsWrapper) {
        self.id = actor.id
        self.firstName = actor.attributes.firstName
        self.lastName = actor.attributes.lastName
        self.role = actor.attributes.character
        self.dateOfBirth = actor.attributes.dateOfBirth
        self.projects = actor.attributes.mcuProjects?.data ?? []
        self.imageUrl = URL(string: actor.attributes.imageURL ?? "")
        self.actor = actor
    }
    
    func getSubtitle() -> String {
        "Actor"
    }
    
    func getSearchString() -> String {
        firstName + " " + lastName + " " + role
    }
    
    func getProjectsTitle() -> String {
        "Played in"
    }
    
    func getPopulated() async -> (any Person)? {
        await ActorService.getActorById(id: self.id)?.person
    }
    
    func getIconName() -> String {
        "star.circle.fill"
    }
}

extension ActorsWrapper {
    var person: any Person {
        get {
            ActorPerson(self)
        }
    }
}
