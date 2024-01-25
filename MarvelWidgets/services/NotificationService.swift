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
        toggleTopic(topic.rawValue)
    }
    
    func toggleTopic(_ topic: String) {
        requestAuthorization()
        
        var topics = UserDefaultsService.standard.subscribeTopics

        if let index = topics.firstIndex(of: topic) {
            topics.remove(at: index)
            Messaging.messaging().unsubscribe(fromTopic: topic)
        } else {
            topics.append(topic)
            Messaging.messaging().subscribe(toTopic: topic)
        }
        
        UserDefaultsService.standard.subscribeTopics = topics
    }
    
    func getTopics() -> [String] {
        UserDefaultsService.standard.subscribeTopics
    }
    
    func isSubscribedTo(topic: NotificationTopics) -> Bool {
        isSubscribedTo(topic: topic.rawValue)
    }
    
    func isSubscribedTo(topic: String) -> Bool {
        getTopics().contains(topic)
    }
    
    private func requestAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
    }
}
