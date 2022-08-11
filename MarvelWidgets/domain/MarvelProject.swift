//
//  MarvelProject.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

protocol Project {
    var id: UUID { get }
    var title: String { get }
    var releaseDate: String? { get }
    var overview: String? { get }
    var coverURL: String { get }
    var directedBy: String? { get }
    var phase: Int { get }
    var saga: Saga? { get }
    var trailerURL: String? { get }
}
