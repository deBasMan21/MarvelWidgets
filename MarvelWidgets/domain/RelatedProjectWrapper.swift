//
//  RelatedProjectWrapper.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct RelatedProjectWrapper: Codable {
    let uuid = UUID()
    let id: Int
    let attributes: MCUProject
    
    enum CodingKeys: String, CodingKey {
        case id, attributes
    }
}
