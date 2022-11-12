//
//  WidgetSettingsViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation
import WidgetKit
import SwiftUI

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
        
        let userDefs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
        
        init() {
            showText = userDefs.bool(forKey: UserDefaultValues.smallWidgetShowText)
            selectedProject = userDefs.integer(forKey: UserDefaultValues.specificSelectedProject)
            selectedProjectTitle = userDefs.string(forKey: UserDefaultValues.specificSelectedProjectTitle)
            Task {
                await MainActor.run {
                    Task {
                        selectedProjectObject = await getProjectById(selectedProject ?? -1)
                        
                        projects = await NewDomainService.getAll()
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
            return await NewDomainService.getById(id)
        }
    }
}


