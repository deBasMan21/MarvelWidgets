//
//  HomepageComponent.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/01/2024.
//

import Foundation

enum HomepageComponent: Codable, Identifiable, Hashable {
    var id: String {
        switch self {
        case .highlight(let component): return "highlight-\(component.id)"
        case .youtube(let component): return "youtube-\(component.id)"
        case .text(let component): return "text-\(component.id)"
        case .title(let component): return "title-\(component.id)"
        case .horizontalList(let component): return "horizontal-\(component.id)"
        case .verticalList(let component): return "vertical-\(component.id)"
        case .spotify(let component): return "spotify-\(component.id)"
        case .nytReview(let component): return "nyt-\(component.id)"
        case .divider(let component): return "divider-\(component.id)"
        case .headerWidget(let component): return "header-\(component.id)"
        case .notificationDialog(let component): return "notification-\(component.id)"
        case .pageLink(let component): return "link-\(component.id)"
        case .none: return UUID().uuidString
        }
    }
    
    case highlight(HighlightComponent)
    case youtube(YoutubeEmbedComponent)
    case text(TextComponent)
    case title(TitleComponent)
    case horizontalList(HorizontalListComponent)
    case verticalList(VerticalListComponent)
    case spotify(SpotifyComponent)
    case nytReview(NytReviewComponent)
    case divider(DividerComponent)
    case headerWidget(HeaderWidgetComponent)
    case notificationDialog(NotificationsDialogComponent)
    case pageLink(PageLinkComponent)
    case none
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let type = try? container.decode(HomepageComponentTypeWrapper.self) else {
            self = .none
            return
        }
        
        self = switch type.type {
        case .highlight:
            if let component = try? container.decode(HighlightComponent.self) {
                .highlight(component)
            } else { .none }
        case .youtube:
            if let component = try? container.decode(YoutubeEmbedComponent.self) {
                .youtube(component)
            } else { .none }
        case .text:
            if let component = try? container.decode(TextComponent.self) {
                .text(component)
            } else { .none }
        case .title:
            if let component = try? container.decode(TitleComponent.self) {
                .title(component)
            } else { .none }
        case .horizontalList:
            if let component = try? container.decode(HorizontalListComponent.self) {
                .horizontalList(component)
            } else { .none }
        case .verticalList:
            if let component = try? container.decode(VerticalListComponent.self) {
                .verticalList(component)
            } else { .none }
        case .spotify:
            if let component = try? container.decode(SpotifyComponent.self) {
                .spotify(component)
            } else { .none }
        case .nytReview:
            if let component = try? container.decode(NytReviewComponent.self) {
                .nytReview(component)
            } else { .none }
        case .divider:
            if let component = try? container.decode(DividerComponent.self) {
                .divider(component)
            } else { .none }
        case .headerWidget:
            if let component = try? container.decode(HeaderWidgetComponent.self) {
                .headerWidget(component)
            } else { .none }
        case .notificationDialog:
            if let component = try? container.decode(NotificationsDialogComponent.self) {
                .notificationDialog(component)
            } else { .none }
        case .pageLink:
            if let component = try? container.decode(PageLinkComponent.self) {
                .pageLink(component)
            } else { .none }
        }
    }
}

struct HomepageComponentTypeWrapper: Codable {
    let type: HomepageComponentType
    
    enum CodingKeys: String, CodingKey {
        case type = "__component"
    }
}

enum HomepageComponentType: String, Codable {
    case highlight = "home-page.highlight-item"
    case youtube = "home-page.youtube-embed"
    case text = "home-page.text-component"
    case title = "home-page.title"
    case horizontalList = "home-page.horizontal-list"
    case verticalList = "home-page.vertical-list"
    case spotify = "home-page.spotify-embed"
    case nytReview = "home-page.nyt-review"
    case divider = "home-page.divider"
    case headerWidget = "home-page.header-widget"
    case notificationDialog = "home-page.notifications-dialog"
    case pageLink = "home-page.page-link"
}
