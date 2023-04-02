//
//  Directors.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct Directors: Codable {
    let data: [DirectorsWrapper]
}

struct SignleDirector: Codable {
    let data: DirectorsWrapper
}
