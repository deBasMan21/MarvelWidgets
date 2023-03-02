//
//  Director.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct Director: Codable {
    let firstName, lastName: String
    let createdAt, updatedAt: String
    let imageURL, dateOfBirth: String?
    let mcuProjects: ListResponseWrapper?
    let relatedProjects: ListResponseWrapper?
 
    enum CodingKeys: String, CodingKey {
        case firstName = "FirstName"
        case lastName = "LastName"
        case createdAt, updatedAt
        case imageURL = "ImageUrl"
        case dateOfBirth = "DateOfBirth"
        case mcuProjects = "mcu_projects"
        case relatedProjects = "related_projects"
    }
}
