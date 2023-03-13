//
//  NotificationService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import FirebaseMessaging
import UserNotifications
import UIKit

class NotificationService {
    init(){}
    
    func toggleTopic(_ topic: NotificationTopics) {
        requestAuthorization()
        
        var topics = UserDefaultsService.standard.subscribeTopics

        if let index = topics.firstIndex(of: topic.rawValue) {
            topics.remove(at: index)
            Messaging.messaging().unsubscribe(fromTopic: topic.rawValue)
        } else {
            topics.append(topic.rawValue)
            Messaging.messaging().subscribe(toTopic: topic.rawValue)
        }
        
        UserDefaultsService.standard.subscribeTopics = topics
    }
    
    func getTopics() -> [String] {
        UserDefaultsService.standard.subscribeTopics
    }
    
    func isSubscribedTo(topic: NotificationTopics) -> Bool {
        return getTopics().contains(topic.rawValue)
    }
    
    private func requestAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
    }
}
