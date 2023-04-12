//
//  ProjectWrapper.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct ProjectWrapper: Codable, Comparable, Hashable {
    static func < (lhs: ProjectWrapper, rhs: ProjectWrapper) -> Bool {
        lhs.attributes > rhs.attributes
    }
    
    static func == (lhs: ProjectWrapper, rhs: ProjectWrapper) -> Bool {
        lhs.attributes == rhs.attributes
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let uuid = UUID()
    let id: Int
    let attributes: MCUProject
    
    func toData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    func getUrl() -> URL? {
        URL(string: "https://mcuwidgets.page.link/\(attributes.type.getUrlTypeString())/\(id)")
    }
}
