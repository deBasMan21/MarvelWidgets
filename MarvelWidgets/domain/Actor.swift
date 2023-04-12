//
//  Actor.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct Actor: Codable {
    let firstName, lastName, character: String
    let dateOfBirth: String?
    let createdAt, updatedAt: String
    let imageURL: String?
    let mcuProjects: ListResponseWrapper?
 
    enum CodingKeys: String, CodingKey {
        case firstName = "FirstName"
        case lastName = "LastName"
        case character = "Character"
        case dateOfBirth = "DateOfBirth"
        case createdAt, updatedAt
        case imageURL = "ImageUrl"
        case mcuProjects = "mcu_projects"
    }
}
