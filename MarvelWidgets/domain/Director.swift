//
//  Director.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct Director: Codable, Hashable {
    let firstName, lastName: String
    let createdAt, updatedAt: String
    let imageURL, dateOfBirth: String?
    let mcuProjects: ListResponseWrapper?
 
    enum CodingKeys: String, CodingKey {
        case firstName = "FirstName"
        case lastName = "LastName"
        case createdAt, updatedAt
        case imageURL = "ImageUrl"
        case dateOfBirth = "DateOfBirth"
        case mcuProjects = "mcu_projects"
    }
}
