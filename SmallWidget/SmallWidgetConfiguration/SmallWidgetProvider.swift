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
    let emptyProject = ProjectWrapper(
        id: -1,
        attributes: MCUProject(
            title: "Next project not available",
            releaseDate: Date.now.addingTimeInterval(60 * 60 * 24 * 2).ISO8601Format(),
            postCreditScenes: nil,
            duration: nil,
            phase: .unkown,
            saga: .infinitySaga,
            overview: nil,
            type: .special,
            boxOffice: nil,
            createdAt: nil,
            updatedAt: nil,
            disneyPlusUrl: nil,
            directors: nil,
            actors: nil,
            relatedProjects: nil,
            trailers: nil,
            posters: nil,
            seasons: nil
        )
    )
    
    var projectEntry: UpcomingProjectEntry {
        return UpcomingProjectEntry(
            date: Date(),
            configuration: WidgetTypeConfigurationIntent(),
            upcomingProject: emptyProject,
            nextProject: emptyProject,
            image: Image("secret wars"),
            nextImage: Image("secret wars")
        )
    }
    
    func placeholder(in context: Context) -> UpcomingProjectEntry {
        projectEntry
    }

    func getSnapshot(for configuration: WidgetTypeConfigurationIntent, in context: Context, completion: @escaping (UpcomingProjectEntry) -> ()) {
        completion(projectEntry)
    }

    func getTimeline(for configuration: WidgetTypeConfigurationIntent, in context: Context, completion: @escaping (Timeline<UpcomingProjectEntry>) -> ()) {
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
                    upcomingProjects.append(contentsOf: await ProjectService.getAll(populate: .populateNormal))
                default: break
                }
                
                entries.append(WidgetProjectService.randomProject(from: upcomingProjects, with: configuration))
            default:
                upcomingProjects = await ProjectService.getFirstUpcoming(for: widgetType)
                
                entries.append(
                    WidgetProjectService.upcomingProject(from: upcomingProjects, with: configuration)
                    ?? projectEntry
                )
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}
