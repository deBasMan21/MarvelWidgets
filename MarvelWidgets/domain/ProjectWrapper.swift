//
//  ProjectWrapper.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct ProjectWrapper: Codable {
    let uuid = UUID()
    let id: Int
    let attributes: MCUProject
    
    func toData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
