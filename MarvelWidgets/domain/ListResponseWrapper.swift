//
//  ListResponseWrapper.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct ListResponseWrapper: Codable, Hashable {
    let data: [ProjectWrapper]
}
