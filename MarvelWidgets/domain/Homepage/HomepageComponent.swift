//
//  HomepageComponent.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/01/2024.
//

import Foundation

enum HomepageComponent: Codable {
    case highlight(HighlightComponent)
    case youtube(YoutubeEmbedComponent)
    case text(TextComponent)
    case title(TitleComponent)
    case actorsList(ActorsPageLinkComponent)
    case directorsList(DirectorsPageLinkComponent)
    case horizontalList(HorizontalListComponent)
    case newsItemsList(NewsItemsListComponent)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = if let highlight = try? container.decode(HighlightComponent.self) {
            .highlight(highlight)
        } else if let youtube = try? container.decode(YoutubeEmbedComponent.self) {
            .youtube(youtube)
        } else if let text = try? container.decode(TextComponent.self) {
            .text(text)
        } else if let title = try? container.decode(TitleComponent.self) {
            .title(title)
        } else if let actorsList = try? container.decode(ActorsPageLinkComponent.self) {
            .actorsList(actorsList)
        } else if let directorsList = try? container.decode(DirectorsPageLinkComponent.self) {
            .directorsList(directorsList)
        } else if let horizontalList = try? container.decode(HorizontalListComponent.self) {
            .horizontalList(horizontalList)
        } else if let newsItemsList = try? container.decode(NewsItemsListComponent.self) {
            .newsItemsList(newsItemsList)
        } else {
            throw DecodingError.typeMismatch(
                HomepageComponent.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Type is not matched",
                    underlyingError: nil
                )
            )
        }
    }
}
