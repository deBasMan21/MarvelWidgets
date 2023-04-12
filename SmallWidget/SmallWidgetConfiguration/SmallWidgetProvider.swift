//
//  SmallWidgetProvider.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 25/02/2023.
//

import WidgetKit
import SwiftUI
import Intents

struct SmallWidgetProvider: IntentTimelineProvider {
    var projectEntry: UpcomingProjectEntry {
        return UpcomingProjectEntry(
            date: Date(),
            configuration: UpcomingWidgetIntent(),
            upcomingProject: Placeholders.emptyProject,
            image: Image("secret wars")
        )
    }
    
    func placeholder(in context: Context) -> UpcomingProjectEntry {
        projectEntry
    }

    func getSnapshot(for configuration: UpcomingWidgetIntent, in context: Context, completion: @escaping (UpcomingProjectEntry) -> ()) {
        completion(projectEntry)
    }

    func getTimeline(for configuration: UpcomingWidgetIntent, in context: Context, completion: @escaping (Timeline<UpcomingProjectEntry>) -> ()) {
        Task {
            var entries: [UpcomingProjectEntry] = []
            var upcomingProjects : [ProjectWrapper] = []
            
            let widgetType: WidgetType = WidgetType.getFromIndex(configuration.WidgetType.rawValue)
            
            switch configuration.RandomOrNext.rawValue {
            case 2:
                switch widgetType {
                case .movies, .series, .special:
                    upcomingProjects.append(contentsOf: await ProjectService.getByType(widgetType, populate: .populateNormal))
                case .all:
                    upcomingProjects.append(contentsOf: await ProjectService.getAll())
                default: break
                }
                
                entries.append(WidgetProjectService.randomProject(from: upcomingProjects, with: configuration))
            default:
                upcomingProjects = await ProjectService.getFirstUpcoming(for: widgetType)
                
                entries.append(WidgetProjectService.upcomingProject(from: upcomingProjects, with: configuration))
            }
            
            completion(Timeline(entries: entries, policy: .atEnd))
        }
    }
}
