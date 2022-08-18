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
        
        @Published var projects: [Project] = []
        @Published var selectedProject: String? = nil
        @Published var selectedProjectTitle: String? = nil
        @Published var selectedProjectObject: Project? = nil
        
        let userDefs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
        
        init() {
            showText = userDefs.bool(forKey: UserDefaultValues.smallWidgetShowText)
            selectedProject = userDefs.string(forKey: UserDefaultValues.specificSelectedProject)
            selectedProjectTitle = userDefs.string(forKey: UserDefaultValues.specificSelectedProjectTitle)
            Task {
                await MainActor.run {
                    Task {
                        selectedProjectObject = await getProjectById(selectedProject ?? "")
                        
                        projects = await MovieService.getMoviesChronologically()
                        projects.append(contentsOf: await SeriesService.getSeriesChronologically())
                    }
                }
            }   
        }
        
        func setSpecificProject(to id: String, with title: String) {
            userDefs.set(id, forKey: UserDefaultValues.specificSelectedProject)
            userDefs.set(title, forKey: UserDefaultValues.specificSelectedProjectTitle)
            selectedProject = id
            selectedProjectTitle = title
            Task {
                await MainActor.run {
                    Task {
                        selectedProjectObject = await getProjectById(selectedProject ?? "")
                    }
                }
            }
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        func setShowText(to showText: Bool) {
            userDefs.set(showText, forKey: UserDefaultValues.smallWidgetShowText)
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        func getProjectById(_ id: String) async -> Project? {
            var proj: Project? = nil
            if id.starts(with: "s") {
                let projId = Int(id.replacingOccurrences(of: "s", with: "")) ?? 0
                proj = await SeriesService.getSerieById(projId)
            } else if id.starts(with: "m") {
                let projId = Int(id.replacingOccurrences(of: "m", with: "")) ?? 0
                proj = await MovieService.getMovieById(projId)
            }
            
            return proj
        }
    }
}


