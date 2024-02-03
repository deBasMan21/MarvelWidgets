//
//  DirectorsWrapper.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct DirectorsWrapper: Codable, Identifiable, Equatable, Hashable  {
    let id: Int
    let attributes: Director
    
    static func == (lhs: DirectorsWrapper, rhs: DirectorsWrapper) -> Bool {
        return lhs.id == rhs.id
    }
}
