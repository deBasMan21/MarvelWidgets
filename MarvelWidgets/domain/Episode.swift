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
