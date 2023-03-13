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
            postCreditScenes: nil,
            duration: nil,
            phase: .unkown,
            saga: .infinitySaga,
            overview: nil,
            type: .movie,
            boxOffice: nil,
            createdAt: nil,
            updatedAt: nil,
            disneyPlusUrl: nil,
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
                            mcuProjects: nil,
                            relatedProjects: nil
                        )
                    )
                ]
            ),
            actors: nil,
            relatedProjects: nil,
            trailers: nil,
            posters: nil,
            seasons: nil
        )
    )
    
    static let smallProjectImage = Image("SmallWidgetPoster")
    static let emptySmallProject = ProjectWrapper(
        id: -1,
        attributes: MCUProject(
            title: "Ant-Man and the Wasp: Quantumania",
            releaseDate: Date.now.addingTimeInterval(60 * 60 * 24 * 2).toOriginalFormattedString(),
            postCreditScenes: nil,
            duration: nil,
            phase: .unkown,
            saga: .infinitySaga,
            overview: nil,
            type: .movie,
            boxOffice: nil,
            createdAt: nil,
            updatedAt: nil,
            disneyPlusUrl: nil,
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
                            mcuProjects: nil,
                            relatedProjects: nil
                        )
                    )
                ]
            ),
            actors: nil,
            relatedProjects: nil,
            trailers: nil,
            posters: nil,
            seasons: nil
        )
    )
}
