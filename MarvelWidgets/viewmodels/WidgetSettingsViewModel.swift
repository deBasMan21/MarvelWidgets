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
        @Published var notificationNews: Bool {
            didSet {
                toggleTopic(Constants.newsTopic)
            }
        }
        
        let userDefs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
        let notificationService = NotificationService()
        
        init() {
            selectedProject = userDefs.integer(forKey: UserDefaultValues.specificSelectedProject)
            selectedProjectTitle = userDefs.string(forKey: UserDefaultValues.specificSelectedProjectTitle)
            notificationNews = notificationService.isSubscribedTo(topic: Constants.newsTopic)
            
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
        
        func toggleTopic(_ topic: String) {
            notificationService.toggleTopic(topic)
        }
    }
}
