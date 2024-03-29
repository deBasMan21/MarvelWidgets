//
//  DirectorPerson.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/04/2023.
//

import Foundation

class DirectorPerson: Person, Hashable {
    static func == (lhs: DirectorPerson, rhs: DirectorPerson) -> Bool {
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
    var dateOfBirth: String?
    var projects: [ProjectWrapper]
    var imageUrl: URL?
    
    private var director: DirectorsWrapper
    
    init(_ director: DirectorsWrapper) {
        self.id = director.id
        self.firstName = director.attributes.firstName
        self.lastName = director.attributes.lastName
        self.dateOfBirth = director.attributes.dateOfBirth
        self.projects = director.attributes.mcuProjects?.data ?? []
        if let imageUrl = director.attributes.imageURL {
            self.imageUrl = URL(string: imageUrl)
        }
        
        self.director = director
    }
    
    func getSubtitle() -> String {
        "Director"
    }
    
    func getSearchString() -> String {
        firstName + " " + lastName
    }
    
    func getProjectsTitle() -> String {
        "Directed"
    }
    
    func getPopulated() async -> (any Person)? {
        await DirectorService.getDirectorById(id: self.id)?.person
    }
    
    func getIconName() -> String {
        "d.circle.fill"
    }
}

extension DirectorsWrapper {
    var person: any Person {
        get {
            DirectorPerson(self)
        }
    }
}

