//
//  PersonType.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/04/2023.
//

import Foundation

enum PersonType: String {
    case actor = "Actors"
    case director = "Directors"
    
    func getPersons() async -> [any Person] {
        switch self {
        case .actor:
            return await ProjectService.getActors().compactMap { $0.person }
        case .director:
            return await ProjectService.getDirectors().compactMap { $0.person }
        }
    }
}
