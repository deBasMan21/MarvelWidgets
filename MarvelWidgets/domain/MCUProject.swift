//
//  MCUProject.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct MCUProject: Codable {
    let title: String
    let releaseDate: String?
    let postCreditScenes, duration: Int?
    let phase: Phase?
    let saga: Saga?
    let overview: String?
    let type: ProjectType
    let boxOffice, createdAt, updatedAt, disneyPlusUrl: String?
    let directors: Directors?
    let actors: Actors?
    let relatedProjects: RelatedProjects?
    let trailers: [Trailer]?
    let posters: [Poster]?
    let seasons: [Season]?
 
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case releaseDate = "ReleaseDate"
        case postCreditScenes = "PostCreditScenes"
        case duration = "Duration"
        case phase = "Phase"
        case saga = "Saga"
        case overview = "Overview"
        case type = "Type"
        case boxOffice = "BoxOffice"
        case createdAt, updatedAt, directors, actors
        case relatedProjects = "related_projects"
        case trailers = "Trailers"
        case posters = "Posters"
        case seasons = "Seasons"
        case disneyPlusUrl = "DisneyPlusUrl"
    }
}
