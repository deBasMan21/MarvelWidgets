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
        @Published var notificationTesting: Bool {
            didSet {
                self.toggleTopic(.testing)
            }
        }
        @Published var notificationRelated: Bool {
            didSet {
                self.toggleTopic(.related)
            }
        }
        
        let userDefs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
        let notificationService = NotificationService()
        
        init() {
            selectedProject = userDefs.integer(forKey: UserDefaultValues.specificSelectedProject)
            selectedProjectTitle = userDefs.string(forKey: UserDefaultValues.specificSelectedProjectTitle)
            
            notificationMovie = notificationService.isSubscribedTo(topic: .movie)
            notificationSerie = notificationService.isSubscribedTo(topic: .serie)
            notificationSpecial = notificationService.isSubscribedTo(topic: .special)
            notificationRelated = notificationService.isSubscribedTo(topic: .related)
            notificationTesting = notificationService.isSubscribedTo(topic: .testing)
            
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
        
        func getProjectById(_ id: Int) async -> ProjectWrapper? {
            return await ProjectService.getById(id)
        }
        
        func toggleTopic(_ topic: NotificationTopics) {
            notificationService.toggleTopic(topic)
        }
    }
}
