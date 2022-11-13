struct ListResponseWrapper: Codable {
    let data: [ProjectWrapper]
}

struct SingleResponseWrapper: Codable {
    let data: ProjectWrapper
}

// Welcome.swift
 
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)
 
import Foundation
 
// MARK: - Welcome
struct ProjectWrapper: Codable {
    let uuid = UUID()
    let id: Int
    let attributes: MCUProject
    
    func toData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
 
// WelcomeAttributes.swift
 
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcomeAttributes = try? newJSONDecoder().decode(WelcomeAttributes.self, from: jsonData)
 
import Foundation
 
// MARK: - WelcomeAttributes
struct MCUProject: Codable {
    let title: String
    let releaseDate: String?
    let postCreditScenes, duration: Int?
    let phase: Phase
    let saga: Saga
    let overview: String?
    let type: ProjectType
    let boxOffice, createdAt, updatedAt: String?
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
    }
}

enum Phase: String, Codable {
    case phase_1 = "Phase 1"
    case phase_2 = "Phase 2"
    case phase_3 = "Phase 3"
    case phase_4 = "Phase 4"
    case phase_5 = "Phase 5"
    case unkown = "Unkown"
}

enum Saga: String, Codable {
    case infinitySaga = "Infinity Saga"
    case multiverseSaga = "Multiverse Saga"
}

enum ProjectType: String, Codable {
    case movie = "Movie"
    case serie = "Serie"
    case special = "Special"
}
 
// Actors.swift
 
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actors = try? newJSONDecoder().decode(Actors.self, from: jsonData)
 
import Foundation
 
// MARK: - Actors
struct Actors: Codable {
    let data: [ActorsWrapper]
}
 
// ActorsDatum.swift
 
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actorsDatum = try? newJSONDecoder().decode(ActorsDatum.self, from: jsonData)
 
import Foundation
 
// MARK: - ActorsDatum
struct ActorsWrapper: Codable {
    let uuid = UUID()
    let id: Int
    let attributes: Actor
}
 
// PurpleAttributes.swift
 
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let purpleAttributes = try? newJSONDecoder().decode(PurpleAttributes.self, from: jsonData)
 
import Foundation
 
// MARK: - PurpleAttributes
struct Actor: Codable {
    let firstName, lastName, character: String
    let dateOfBirth: String?
    let createdAt, updatedAt: String
    let imageURL: String?
 
    enum CodingKeys: String, CodingKey {
        case firstName = "FirstName"
        case lastName = "LastName"
        case character = "Character"
        case dateOfBirth = "DateOfBirth"
        case createdAt, updatedAt
        case imageURL = "ImageUrl"
    }
}
 
// Directors.swift
 
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let directors = try? newJSONDecoder().decode(Directors.self, from: jsonData)
 
import Foundation
 
// MARK: - Directors
struct Directors: Codable {
    let data: [DirectorsWrapper]
}
 
// DirectorsDatum.swift
 
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let directorsDatum = try? newJSONDecoder().decode(DirectorsDatum.self, from: jsonData)
 
import Foundation
 
// MARK: - DirectorsDatum
struct DirectorsWrapper: Codable {
    let uuid = UUID()
    let id: Int
    let attributes: Director
}
 
// FluffyAttributes.swift
 
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fluffyAttributes = try? newJSONDecoder().decode(FluffyAttributes.self, from: jsonData)
 
import Foundation
 
// MARK: - FluffyAttributes
struct Director: Codable {
    let firstName, lastName: String
    let createdAt, updatedAt: String
    let imageURL: String?
 
    enum CodingKeys: String, CodingKey {
        case firstName = "FirstName"
        case lastName = "LastName"
        case createdAt, updatedAt
        case imageURL = "ImageUrl"
    }
}
 
// Poster.swift
 
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let poster = try? newJSONDecoder().decode(Poster.self, from: jsonData)
 
import Foundation
 
// MARK: - Poster
struct Poster: Codable, Identifiable, Equatable {
    let id: Int
    let posterURL: String
 
    enum CodingKeys: String, CodingKey {
        case id
        case posterURL = "PosterUrl"
    }
}
 
// RelatedProjects.swift
 
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let relatedProjects = try? newJSONDecoder().decode(RelatedProjects.self, from: jsonData)
 
import Foundation
 
// MARK: - RelatedProjects
struct RelatedProjects: Codable {
    let data: [ProjectWrapper]
}

struct RelatedProjectWrapper: Codable {
    let uuid = UUID()
    let id: Int
    let attributes: MCUProject
    
    enum CodingKeys: String, CodingKey {
        case id, attributes
    }
}

struct RelatedProject: Codable {
    let title: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case releaseDate = "ReleaseDate"
    }
}
 
// Trailer.swift
 
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let trailer = try? newJSONDecoder().decode(Trailer.self, from: jsonData)
 
import Foundation
 
// MARK: - Trailer
struct Trailer: Codable, Identifiable, Equatable {
    let id: Int
    let trailerName: String
    let youtubeLink: String
 
    enum CodingKeys: String, CodingKey {
        case id
        case trailerName = "TrailerName"
        case youtubeLink = "YoutubeLink"
    }
}


// Welcome.swift
 
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)
 
import Foundation
 
// MARK: - Welcome
struct Season: Codable {
    let uuid = UUID()
    let id: Int
    let seasonNumber: Int
    let numberOfEpisodes: Int?
    let episodes: [Episode]?
    let seasonTrailers: [Trailer]?
    let posters: [Poster]?
 
    enum CodingKeys: String, CodingKey {
        case id
        case seasonNumber = "SeasonNumber"
        case numberOfEpisodes = "NumberOfEpisodes"
        case episodes = "Episodes"
        case seasonTrailers = "SeasonTrailers"
        case posters = "Posters"
    }
}
 
// Episode.swift
 
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let episode = try? newJSONDecoder().decode(Episode.self, from: jsonData)
 
import Foundation
 
// MARK: - Episode
struct Episode: Codable, Identifiable, Equatable {
    let uuid = UUID()
    let id: Int
    let title, episodeDescription: String
    let postCreditScenes: Int
    let episodeReleaseDate: String
    let episodeNumber, duration: Int
 
    enum CodingKeys: String, CodingKey {
        case id
        case title = "Title"
        case episodeDescription = "Description"
        case postCreditScenes = "PostCreditScenes"
        case episodeReleaseDate = "EpisodeReleaseDate"
        case episodeNumber = "EpisodeNumber"
        case duration = "Duration"
    }
}
