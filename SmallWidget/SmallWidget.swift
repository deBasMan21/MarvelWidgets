//
//  SmallWidget.swift
//  SmallWidget
//
//  Created by Bas Buijsen on 10/08/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct SmallWidgetProvider: IntentTimelineProvider {
    let emptyProject = ProjectWrapper(
        id: -1,
        attributes: MCUProject(
            title: "Next project",
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
    
    func placeholder(in context: Context) -> UpcomingProjectEntry {
        return UpcomingProjectEntry(
            date: Date(),
            configuration: WidgetTypeConfigurationIntent(),
            upcomingProject: emptyProject,
            nextProject: emptyProject,
            image: Image("secret wars"),
            nextImage: Image("secret wars")
        )
    }

    func getSnapshot(for configuration: WidgetTypeConfigurationIntent, in context: Context, completion: @escaping (UpcomingProjectEntry) -> ()) {
        let entry = UpcomingProjectEntry(
            date: Date(),
            configuration: WidgetTypeConfigurationIntent(),
            upcomingProject: emptyProject,
            nextProject: emptyProject,
            image: Image("secret wars"),
            nextImage: Image("secret wars")
        )
        
        completion(entry)
    }

    func getTimeline(for configuration: WidgetTypeConfigurationIntent, in context: Context, completion: @escaping (Timeline<UpcomingProjectEntry>) -> ()) {
        Task {
            var entries: [UpcomingProjectEntry] = []
            var upcomingProjects : [ProjectWrapper] = []
            
            let widgetType: WidgetType = WidgetType.getFromIndex(configuration.WidgetType.rawValue)
            
            switch widgetType {
            case .movies:
                upcomingProjects.append(contentsOf: await ProjectService.getByType(.movies, populate: .populateNormal))
            case .series:
                upcomingProjects.append(contentsOf: await ProjectService.getByType(.series, populate: .populateNormal))
            case .special:
                upcomingProjects.append(contentsOf: await ProjectService.getByType(.special, populate: .populateNormal))
            case .all:
                upcomingProjects.append(contentsOf: await ProjectService.getAll(populate: .populateNormal))
            case .saved:
                upcomingProjects.append(contentsOf: SaveService.getProjectsFromUserDefaults())
            }
            
            switch configuration.RandomOrNext.rawValue {
            case 2:
                entries.append(WidgetProjectService.randomProject(from: upcomingProjects, with: configuration))
            default:
                entries.append(WidgetProjectService.upcomingProject(from: upcomingProjects, with: configuration))
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct UpcomingProjectEntry: TimelineEntry {
    let date: Date
    let configuration: WidgetTypeConfigurationIntent
    let upcomingProject: ProjectWrapper?
    let nextProject: ProjectWrapper?
    let image: Image
    let nextImage: Image?
}

struct SmallWidgetUpcoming : View {
    @Environment(\.widgetFamily) var family
    var entry: SmallWidgetProvider.Entry

    var body: some View {
        if let project = entry.upcomingProject {
            switch family{
            case .systemMedium:
                SmallWidgetUpcomingMedium(upcomingProject: project, image: entry.image)
            case .systemSmall:
                SmallWidgetUpcomingSmall(upcomingProject: project, image: entry.image)
            case .systemLarge:
                if let nextProject = entry.nextProject, let nextImage = entry.nextImage {
                    VStack {
                        SmallWidgetUpcomingMedium(upcomingProject: project, image: entry.image)
                        SmallWidgetUpcomingMedium(upcomingProject: nextProject, image: nextImage)
                    }
                } else {
                    Text("No project")
                }
            case .accessoryCircular:
                AccessoryCircularWidget(project: project)
            case .accessoryInline:
                AccessoryInlineWidget(project: project)
            case .accessoryRectangular:
                AccessoryRectengularWidget(project: project)
            default:
                Text("Not implemented")
            }
        } else {
            Text("No project")
        }
    }
}

struct SmallWidget: Widget {
    let kind: String = "SmallWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: WidgetTypeConfigurationIntent.self, provider: SmallWidgetProvider()) { entry in
            SmallWidgetUpcoming(entry: entry)
        }
        .configurationDisplayName("Any MCU Project")
        .description("This widget shows a MCU project with a countdown if the project is not released yet. This widget has configuration settings to change it to your needs.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryInline, .accessoryRectangular])
    }
}
