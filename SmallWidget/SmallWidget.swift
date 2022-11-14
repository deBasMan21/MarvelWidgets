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
            title: "",
            releaseDate: nil,
            postCreditScenes: nil,
            duration: nil,
            phase: .unkown,
            saga: .infinitySaga,
            overview: nil,
            type: .special,
            boxOffice: nil,
            createdAt: nil,
            updatedAt: nil,
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

    func getTimeline(for configuration: WidgetTypeConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
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
                entries.append(randomProject(from: upcomingProjects, with: configuration))
            default:
                entries.append(upcomingProject(from: upcomingProjects, with: configuration))
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    func upcomingProject(from allProjects: [ProjectWrapper], with configuration: WidgetTypeConfigurationIntent) -> UpcomingProjectEntry {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var smallestDateProject : ProjectWrapper? = nil
        var nextSmallestDateProject: ProjectWrapper? = nil
        
        let proj = allProjects
            .map({ proj in
                let date = formatter.date(
                    from: proj.attributes.releaseDate ?? "2000-01-01"
                ) ?? Date.now.addingTimeInterval(-60 * 60 * 24 * 1000)
                
                return (proj, date)
            }).filter({ tuple in
                tuple.1 > Date.now
            }).sorted(by: { $0.1 < $1.1 })
            .prefix(2)
        
        for (index, projItem) in proj.enumerated() {
            if index == 0 { smallestDateProject = projItem.0 }
            else if index == 1 { nextSmallestDateProject = projItem.0 }
        }
        
        if let smallestDateProject = smallestDateProject, let nextSmallestDateProject = nextSmallestDateProject {
            let image = ImageHelper.downloadImage(
                from: smallestDateProject.attributes.posters?.randomElement()?.posterURL ?? ""
            )
            
            let nextImage = ImageHelper.downloadImage(
                from: nextSmallestDateProject.attributes.posters?.randomElement()?.posterURL ?? ""
            )
            
            return UpcomingProjectEntry(
                date: Date.now,
                configuration: configuration,
                upcomingProject: smallestDateProject,
                nextProject: nextSmallestDateProject,
                image: image,
                nextImage: nextImage
            )
        } else {
            let image = ImageHelper.downloadImage(
                from: allProjects[0].attributes.posters?.randomElement()?.posterURL ?? ""
            )
            
            let nextImage = ImageHelper.downloadImage(
                from: allProjects[1].attributes.posters?.randomElement()?.posterURL ?? ""
            )
            
            return UpcomingProjectEntry(
                date: Date.now,
                configuration: configuration,
                upcomingProject: allProjects[0],
                nextProject: allProjects[1],
                image: image,
                nextImage: nextImage
            )
        }
    }
    
    func randomProject(from allProjects: [ProjectWrapper], with configuration: WidgetTypeConfigurationIntent) -> UpcomingProjectEntry{
        let project = allProjects.randomElement()
        var nextProject = allProjects.randomElement()
        
        while project?.id == nextProject?.id {
            nextProject = allProjects.randomElement()
        }
        
        if let project = project, let nextProject = nextProject {
            let image = ImageHelper.downloadImage(
                from: project.attributes.posters?.randomElement()?.posterURL ?? ""
            )
            
            let nextImage = ImageHelper.downloadImage(
                from: nextProject.attributes.posters?.randomElement()?.posterURL ?? ""
            )
            
            return UpcomingProjectEntry(
                date: Date.now,
                configuration: configuration,
                upcomingProject: project,
                nextProject: nextProject,
                image: image,
                nextImage: nextImage
            )
        } else {
            let image = ImageHelper.downloadImage(
                from: allProjects[0].attributes.posters?.randomElement()?.posterURL ?? ""
            )
            
            let nextImage = ImageHelper.downloadImage(
                from: allProjects[1].attributes.posters?.randomElement()?.posterURL ?? ""
            )
            
            return UpcomingProjectEntry(
                date: Date.now,
                configuration: configuration,
                upcomingProject: allProjects[0],
                nextProject: allProjects[1],
                image: image,
                nextImage: nextImage
            )
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
        .configurationDisplayName("Upcoming MCU")
        .description("This widget shows a MCU project with a countdown if the project is not released yet. This widget has configuration settings to change it to your needs.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
