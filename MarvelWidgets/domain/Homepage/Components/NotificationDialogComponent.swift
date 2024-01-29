//
//  NotificationDialogComponent.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 25/01/2024.
//

import Foundation

struct NotificationsDialogComponent: Codable {
    let id: Int
    let title: String
    let description: String
    let topics: [NotificationsDialogTopic]
}

struct NotificationsDialogTopic: Codable, Identifiable {
    let id: Int
    let topic: String
}
