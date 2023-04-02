//
//  Actors.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct Actors: Codable {
    let data: [ActorsWrapper]
}

struct SingleActor: Codable {
    let data: ActorsWrapper
}
