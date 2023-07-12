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
            let widgetSource: ProjectSource? = ProjectSource.fromWidgetEnum(configuration.Source.rawValue)
            
            switch configuration.RandomOrNext {
            case .random:
                upcomingProjects.append(contentsOf: await ProjectService.getByTypeAndSource(type: widgetType, source: widgetSource, populate: .populateWidget, force: true))
                
                entries.append(WidgetProjectService.randomProject(from: upcomingProjects, with: configuration, widgetFamily: context.family))
            default:
                upcomingProjects = await ProjectService.getFirstUpcoming(for: widgetType, source: widgetSource, populate: .populateWidget, force: true)
                
                entries.append(WidgetProjectService.upcomingProject(from: upcomingProjects, with: configuration, widgetFamily: context.family))
            }
            
            completion(Timeline(entries: entries, policy: .atEnd))
        }
    }
}
