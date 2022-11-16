//
//  WidgetSettingsViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation
import WidgetKit
import SwiftUI
import FirebaseMessaging

extension WidgetSettingsView {
    class WidgetSettingsViewModel: ObservableObject {
        @Published var showText: Bool = true {
            didSet {
                setShowText(to: showText)
            }
        }
        
        @Published var projects: [ProjectWrapper] = []
        @Published var selectedProject: Int? = nil
        @Published var selectedProjectTitle: String? = nil
        @Published var selectedProjectObject: ProjectWrapper? = nil
        
        @Published var notificationMovie: Bool {
            didSet {
                self.toggleTopic(.movie)
            }
        }
        @Published var notificationSerie: Bool {
            didSet {
                self.toggleTopic(.serie)
            }
        }
        @Published var notificationSpecial: Bool {
            didSet {
                self.toggleTopic(.special)
            }
        }
        
        let userDefs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
        
        init() {
            showText = userDefs.bool(forKey: UserDefaultValues.smallWidgetShowText)
            selectedProject = userDefs.integer(forKey: UserDefaultValues.specificSelectedProject)
            selectedProjectTitle = userDefs.string(forKey: UserDefaultValues.specificSelectedProjectTitle)
            
            let topics = UserDefaultsService.standard.subscribeTopics
            notificationMovie = topics.firstIndex(of: NotificationTopics.movie.rawValue) != nil
            notificationSerie = topics.firstIndex(of: NotificationTopics.serie.rawValue) != nil
            notificationSpecial = topics.firstIndex(of: NotificationTopics.special.rawValue) != nil
            
            Task {
                await MainActor.run {
                    Task {
                        selectedProjectObject = await getProjectById(selectedProject ?? -1)
                        
                        projects = await ProjectService.getAll()
                    }
                }
            }
        }
        
        func setSpecificProject(to id: Int, with title: String) {
            userDefs.set(id, forKey: UserDefaultValues.specificSelectedProject)
            userDefs.set(title, forKey: UserDefaultValues.specificSelectedProjectTitle)
            selectedProject = id
            selectedProjectTitle = title
            Task {
                await MainActor.run {
                    Task {
                        selectedProjectObject = await getProjectById(selectedProject ?? -1)
                    }
                }
            }
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        func setShowText(to showText: Bool) {
            userDefs.set(showText, forKey: UserDefaultValues.smallWidgetShowText)
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        func getProjectById(_ id: Int) async -> ProjectWrapper? {
            return await ProjectService.getById(id)
        }
        
        func toggleTopic(_ topic: NotificationTopics) {
            var topics = UserDefaultsService.standard.subscribeTopics

            if let index = topics.firstIndex(of: topic.rawValue) {
                print("unsubscribed \(topic.rawValue)")
                topics.remove(at: index)
                Messaging.messaging().unsubscribe(fromTopic: topic.rawValue)
            } else {
                print("subscribed \(topic.rawValue)")
                topics.append(topic.rawValue)
                Messaging.messaging().subscribe(toTopic: topic.rawValue)
            }
            
            UserDefaultsService.standard.subscribeTopics = topics
        }
    }
    
    enum NotificationTopics: String, CaseIterable {
        case movie = "Movie"
        case serie = "Serie"
        case special = "Special"
    }
}


