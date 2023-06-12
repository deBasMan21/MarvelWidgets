//
//  RecommendationService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/06/2023.
//

import Foundation

class RecommendationService {
    private static var config: Config {
        if UserDefaultsService.standard.useConfig,
            !UserDefaultsService.standard.token.isEmpty,
            !UserDefaultsService.standard.baseUrl.isEmpty {
            return DebugConfig.standard
        } else {
            return ProductionConfig.standard
        }
    }
    
    static func getRecommendations(page: Int) async -> [any SwipingContent] {
        let url = "\(config.trackingUrl)/recommendations/mostPopular?page=\(page)&pageSize=5"
        let result = try? await APIService.apiCall(url: url, body: nil, method: "GET", as: [RecommendationReturnType].self)
        
        guard let result = result else { return [] }
        
        let swipingContent: [any SwipingContent] = result.compactMap {
            switch $0 {
            case .project(let project):
                return project.toProjectSwipingContent()
            case .actor(let actor):
                return actor.toActorSwipingContent()
            case .director(let director):
                return director.toDirectorSwipingContent()
            }
        }
        
        return swipingContent
    }
}

enum RecommendationReturnType: Codable {
    case project(ProjectRecommendation)
    case actor(ActorRecommendation)
    case director(DirectorRecommendation)
    
    enum CodingKeys: String, CodingKey {
        case pageType = "pageType"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let singleContainer = try decoder.singleValueContainer()
        
        let type = try container.decode(String.self, forKey: .pageType)
        switch type {
        case "ACTOR":
            let actor = try singleContainer.decode(ActorRecommendation.self)
            self = .actor(actor)
        case "DIRECTOR":
            let director = try singleContainer.decode(DirectorRecommendation.self)
            self = .director(director)
        case "PROJECT":
            let project = try singleContainer.decode(ProjectRecommendation.self)
            self = .project(project)
        default:
            throw DecodingError.keyNotFound(CodingKeys.pageType, .init(codingPath: [CodingKeys.pageType], debugDescription: "PageType not found"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()
        
        switch self {
        case .project(let project):
            try singleContainer.encode(project)
        case .actor(let actor):
            try singleContainer.encode(actor)
        case .director(let director):
            try singleContainer.encode(director)
        }
    }
}

struct ProjectRecommendation: Codable {
    let id: Int
    let title: String
    let releaseDate: String
    let overview: String
    let imdb_id: String
    let categories: String
    let posterUrl: String
    let type: String
    
    func toProjectSwipingContent() -> ProjectSwipingContent? {
        guard let type = ProjectType(rawValue: type) else { return nil }
        
        return ProjectSwipingContent(
            project: ProjectWrapper(
                id: id,
                attributes: MCUProject(
                    title: title,
                    releaseDate: releaseDate,
                    releaseDateStringOverride: nil,
                    postCreditScenes: nil,
                    duration: nil,
                    voteCount: nil,
                    awardsNominated: nil,
                    awardsWon: nil,
                    productionBudget: nil,
                    phase: nil,
                    saga: nil,
                    overview: overview,
                    type: type,
                    boxOffice: nil,
                    createdAt: nil,
                    updatedAt: nil,
                    disneyPlusUrl: nil,
                    categories: categories,
                    quote: nil,
                    quoteCaption: nil,
                    directors: nil,
                    actors: nil,
                    relatedProjects: nil,
                    trailers: nil,
                    posters: [
                        Poster(
                            id: 0,
                            posterURL: posterUrl
                        )
                    ],
                    seasons: nil,
                    rating: nil,
                    reviewTitle: nil,
                    reviewSummary: nil,
                    reviewCopyright: nil,
                    rankingDifference: nil,
                    rankingCurrentRank: nil,
                    rankingChangeDirection: nil,
                    chronology: nil,
                    episodes: nil
                )
            )
        )
    }
}

struct ActorRecommendation: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let dateOfBirth: String
    let imageUrl: String
    let character: String
    
    func toActorSwipingContent() -> PersonSwipingContent {
        return PersonSwipingContent(
            person: ActorPerson(
                ActorsWrapper(
                    id: id,
                    attributes: Actor(
                        firstName: firstName,
                        lastName: lastName,
                        character: character,
                        dateOfBirth: dateOfBirth,
                        createdAt: "",
                        updatedAt: "",
                        imageURL: imageUrl,
                        mcuProjects: nil
                    )
                )
            )
        )
    }
}

class DirectorRecommendation: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let dateOfBirth: String
    let imageUrl: String
    
    func toDirectorSwipingContent() -> PersonSwipingContent {
        return PersonSwipingContent(
            person: DirectorPerson(
                DirectorsWrapper(
                    id: id,
                    attributes: Director(
                        firstName: firstName,
                        lastName: lastName,
                        createdAt: "",
                        updatedAt: "",
                        imageURL: imageUrl,
                        dateOfBirth: dateOfBirth,
                        mcuProjects: nil
                    )
                )
            )
        )
    }
}
