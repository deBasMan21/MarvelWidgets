//
//  Person.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/04/2023.
//

import Foundation

protocol Person: Hashable {
    var id: Int { get }
    var firstName: String { get }
    var lastName: String { get }
    var dateOfBirth: String? { get }
    var projects: [ProjectWrapper] { get }
    var imageUrl: URL? { get }
    
    func getSubtitle() -> String
    func getSearchString() -> String
    func getProjectsTitle() -> String
    func getPopulated() async -> (any Person)?
}
