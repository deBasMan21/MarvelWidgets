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
    let title: String
    let episodeDescription: String?
    let postCreditScenes: Int?
    let episodeReleaseDate: String?
    let episodeNumber: Int
    let duration: Int?
    let rating: Double?
    let voteCount: Int?
    let imageUrl: String?
    let imageCaption: String?
    let categories: String?
 
    enum CodingKeys: String, CodingKey {
        case id
        case title = "Title"
        case episodeDescription = "Description"
        case postCreditScenes = "PostCreditScenes"
        case episodeReleaseDate = "EpisodeReleaseDate"
        case episodeNumber = "EpisodeNumber"
        case duration = "Duration"
        case rating = "Rating"
        case voteCount
        case imageUrl
        case imageCaption
        case categories
    }
    
    func getUrlString(large: Bool) -> String {
        if let imageUrl = imageUrl {
            return imageUrl.replaceUrlPlaceholders(imageSize: ImageSize(size: .still(large ? .original : .w300)))
        } else {
            return "https://mcuwidgets.buijsenserver.nl/uploads/mcu_Widgets_Logo_Dark_3de3442c2b_86a938dd99.png"
        }
    }
    
    func getUrl(large: Bool) -> URL {
        URL(string: getUrlString(large: large))!
    }
    
    func toProjectWrapper(source: ProjectSource) -> ProjectWrapper {
        return ProjectWrapper(
            id: id,
            attributes: MCUProject(
                title: title,
                releaseDate: episodeReleaseDate,
                releaseDateStringOverride: nil,
                postCreditScenes: postCreditScenes,
                duration: duration,
                voteCount: voteCount,
                awardsNominated: nil,
                awardsWon: nil,
                productionBudget: nil,
                phase: nil,
                saga: nil,
                overview: episodeDescription,
                spotifyEmbed: nil,
                backdropUrl: nil,
                type: .serie,
                source: source,
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
                        posterURL: getUrlString(large: true)
                    )
                ],
                seasons: nil,
                rating: rating,
                reviewTitle: nil,
                reviewSummary: nil,
                reviewCopyright: nil,
                rankingDifference: nil,
                rankingCurrentRank: nil,
                rankingChangeDirection: nil,
                chronology: nil,
                episodes: nil,
                collection: nil, 
                notificationTopic: nil
            )
        )
    }
}
