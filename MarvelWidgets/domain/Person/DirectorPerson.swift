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
        self.imageUrl = URL(string: director.attributes.imageURL ?? "")
        
        self.director = director
    }
    
    func getSubtitle() -> String {
        dateOfBirth?.toDate()?.toFormattedString() ?? "No Date Of Birth"
    }
    
    func getSearchString() -> String {
        firstName + " " + lastName
    }
    
    func getProjectsTitle() -> String {
        "Directed"
    }
    
    func getPopulated() async -> (any Person)? {
        await ProjectService.getDirectorById(id: self.id)?.person
    }
}

extension DirectorsWrapper {
    var person: any Person {
        get {
            DirectorPerson(self)
        }
    }
}

