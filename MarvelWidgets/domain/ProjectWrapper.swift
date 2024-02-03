//
//  ProjectWrapper.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct ProjectWrapper: Codable, Comparable, Hashable, Identifiable {
    static func < (lhs: ProjectWrapper, rhs: ProjectWrapper) -> Bool {
        lhs.attributes > rhs.attributes
    }
    
    static func == (lhs: ProjectWrapper, rhs: ProjectWrapper) -> Bool {
        lhs.attributes == rhs.attributes
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let attributes: MCUProject
    
    func toData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    func getUrl() -> String {
        InternalUrlBuilder.createUrl(entity: .project, id: id, homepage: false)
    }
}
