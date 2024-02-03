//
//  Placeholders.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

class Placeholders {
    static let mediumProjectImage = Image("MediumWidgetPoster")
    static let emptyMediumProject = ProjectWrapper(
        id: -1,
        attributes: MCUProject(
            title: "Black panther: Wakanda Forever",
            releaseDate: Date.now.addingTimeInterval(60 * 60 * 24 * 2).toOriginalFormattedString(),
            releaseDateStringOverride: nil,
            postCreditScenes: nil,
            duration: nil,
            voteCount: nil,
            awardsNominated: nil,
            awardsWon: nil,
            productionBudget: nil,
            phase: .unkown,
            saga: .infinitySaga,
            overview: "",
            spotifyEmbed: nil,
            backdropUrl: nil,
            type: .movie,
            source: .mcu,
            boxOffice: nil,
            createdAt: nil,
            updatedAt: nil,
            disneyPlusUrl: nil,
            categories: nil,
            quote: nil,
            quoteCaption: nil,
            directors: Directors(
                data: [
                    DirectorsWrapper(
                        id: 1,
                        attributes: Director(
                            firstName: "Ryan",
                            lastName: "Coogler",
                            createdAt: "",
                            updatedAt: "",
                            imageURL: nil,
                            dateOfBirth: "1986-05-23",
                            mcuProjects: nil
                        )
                    )
                ]
            ),
            actors: nil,
            relatedProjects: nil,
            trailers: nil,
            posters: nil,
            seasons: nil,
            rating: nil,
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
    
    static let smallProjectImage = Image("SmallWidgetPoster")
    static let emptySmallProject = ProjectWrapper(
        id: -1,
        attributes: MCUProject(
            title: "Ant-Man and the Wasp: Quantumania",
            releaseDate: Date.now.addingTimeInterval(60 * 60 * 24 * 2).toOriginalFormattedString(),
            releaseDateStringOverride: nil,
            postCreditScenes: nil,
            duration: nil,
            voteCount: nil,
            awardsNominated: nil,
            awardsWon: nil,
            productionBudget: nil,
            phase: .unkown,
            saga: .infinitySaga,
            overview: "",
            spotifyEmbed: nil,
            backdropUrl: nil,
            type: .movie,
            source: .mcu,
            boxOffice: nil,
            createdAt: nil,
            updatedAt: nil,
            disneyPlusUrl: nil,
            categories: nil,
            quote: nil,
            quoteCaption: nil,
            directors: Directors(
                data: [
                    DirectorsWrapper(
                        id: 1,
                        attributes: Director(
                            firstName: "Peyton",
                            lastName: "Reed",
                            createdAt: "",
                            updatedAt: "",
                            imageURL: nil,
                            dateOfBirth: "1964-07-03",
                            mcuProjects: nil
                        )
                    )
                ]
            ),
            actors: nil,
            relatedProjects: nil,
            trailers: nil,
            posters: nil,
            seasons: nil,
            rating: nil,
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
    
    static let emptyProject = ProjectWrapper(
        id: -1,
        attributes: MCUProject(
            title: "Select projects in the settings of this widget",
            releaseDate: nil,
            releaseDateStringOverride: nil,
            postCreditScenes: nil,
            duration: nil,
            voteCount: nil,
            awardsNominated: nil,
            awardsWon: nil,
            productionBudget: nil,
            phase: .unkown,
            saga: .infinitySaga,
            overview: "",
            spotifyEmbed: nil,
            backdropUrl: nil,
            type: .special,
            source: .mcu,
            boxOffice: nil,
            createdAt: nil,
            updatedAt: nil,
            disneyPlusUrl: nil,
            categories: nil,
            quote: nil,
            quoteCaption: nil,
            directors: nil,
            actors: nil,
            relatedProjects: nil,
            trailers: nil,
            posters: nil,
            seasons: nil,
            rating: nil,
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
    
    static func loadingProject(id: Int) -> ProjectWrapper {
        ProjectWrapper(
            id: id,
            attributes: MCUProject(
                title: "Loading...",
                releaseDate: nil,
                releaseDateStringOverride: nil,
                postCreditScenes: nil,
                duration: nil,
                voteCount: nil,
                awardsNominated: nil,
                awardsWon: nil,
                productionBudget: nil,
                phase: .unkown,
                saga: .infinitySaga,
                overview: "",
                spotifyEmbed: nil,
                backdropUrl: nil,
                type: .movie,
                source: .mcu,
                boxOffice: nil,
                createdAt: nil,
                updatedAt: nil,
                disneyPlusUrl: nil,
                categories: nil,
                quote: nil,
                quoteCaption: nil,
                directors: nil,
                actors: nil,
                relatedProjects: nil,
                trailers: nil,
                posters: nil,
                seasons: nil,
                rating: nil,
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
    
    static func loadingActor(id: Int) -> ActorsWrapper {
        ActorsWrapper(
            id: id,
            attributes: Actor(
                firstName: "",
                lastName: "",
                character: nil,
                dateOfBirth: nil,
                createdAt: "",
                updatedAt: "",
                imageURL: nil,
                mcuProjects: nil
            )
        )
    }
    
    static func loadingDirector(id: Int) -> DirectorsWrapper {
        DirectorsWrapper(
            id: id,
            attributes: Director(
                firstName: "",
                lastName: "",
                createdAt: "",
                updatedAt: "",
                imageURL: nil,
                dateOfBirth: nil,
                mcuProjects: nil
            )
        )
    }
    
    static func loadingNews(id: Int) -> NewsItemWrapper {
        NewsItemWrapper(
            id: id,
            attributes: NewsItem(
                guid: "",
                url: "",
                title: "",
                summary: "",
                date_published: "",
                author: "",
                content: "",
                categories: nil,
                imageUrl: ""
            )
        )
    }
    
    static func loadingPage(id: Int) -> CustomPageWrapper {
        CustomPageWrapper(
            id: id,
            attributes: CustomPage(
                components: nil,
                title: "",
                parallaxConfig: nil,
                imageUrl: "",
                showShareButton: true
            )
        )
    }
    
    static func loadingCollection(id: Int) -> ProjectCollection {
        ProjectCollection(
            id: id,
            attributes: CollectionAttributes(
                name: "",
                backdropUrl: nil,
                overview: "",
                projects: nil
            )
        )
    }
}
