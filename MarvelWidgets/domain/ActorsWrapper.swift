//
//  ActorsWrapper.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct ActorsWrapper: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let attributes: Actor
    
    static func == (lhs: ActorsWrapper, rhs: ActorsWrapper) -> Bool {
        return lhs.id == rhs.id
    }
}
