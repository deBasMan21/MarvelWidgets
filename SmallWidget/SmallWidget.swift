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
    func placeholder(in context: Context) -> UpcomingProjectEntry {
        let project = Movie(projectId: 0, title: "Avengers: Secret Wars", boxOffice: "", releaseDate: "2025-11-07", duration: 0, overview: nil, coverURL: "", trailerURL: "", directedBy: "", phase: 0, saga: .infinitySaga, chronology: 0, postCreditScenes: 0, imdbID: "", relatedMovies: nil)
        
        return UpcomingProjectEntry(date: Date(), configuration: WidgetTypeConfigurationIntent(), upcomingProject: project, nextProject: project, image: Image("secret wars"), nextImage: Image("secret wars"))
    }

    func getSnapshot(for configuration: WidgetTypeConfigurationIntent, in context: Context, completion: @escaping (UpcomingProjectEntry) -> ()) {
        let project = Movie(projectId: 0, title: "Avengers: Secret Wars", boxOffice: "", releaseDate: "2025-11-07", duration: 0, overview: nil, coverURL: "", trailerURL: "", directedBy: "", phase: 0, saga: .infinitySaga, chronology: 0, postCreditScenes: 0, imdbID: "", relatedMovies: nil)
        
        let entry = UpcomingProjectEntry(date: Date(), configuration: WidgetTypeConfigurationIntent(), upcomingProject: project, nextProject: project, image: Image("secret wars"), nextImage: Image("secret wars"))
        completion(entry)
    }

    func getTimeline(for configuration: WidgetTypeConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            var entries: [UpcomingProjectEntry] = []
            var upcomingProjects : [Project] = []
            
            let widgetType: WidgetType = WidgetType.getFromIndex(configuration.WidgetType.rawValue)
            
            switch widgetType {
            case .movies:
                upcomingProjects.append(contentsOf: await MovieService.getMoviesChronologically())
            case .series:
                upcomingProjects.append(contentsOf: await SeriesService.getSeriesChronologically())
            case .all:
                upcomingProjects.append(contentsOf: await MovieService.getMoviesChronologically())
                upcomingProjects.append(contentsOf: await SeriesService.getSeriesChronologically())
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
    
    func upcomingProject(from allProjects: [Project], with configuration: WidgetTypeConfigurationIntent) -> UpcomingProjectEntry {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var smallestDateProject : Project? = nil
        var nextSmallestDateProject: Project? = nil
        for item in allProjects {
            let date = formatter.date(from: item.releaseDate ?? "2000-01-01")
            let temp = formatter.date(from: smallestDateProject?.releaseDate ?? "3000-01-01")
            
            if let date = date, let temp = temp, date > Date.now && date < temp {
                nextSmallestDateProject = smallestDateProject
                smallestDateProject = item
            }
        }
        
        if let smallestDateProject = smallestDateProject, let nextSmallestDateProject = nextSmallestDateProject {
            let image = ImageHelper.downloadImage(from: smallestDateProject.coverURL)
            let nextImage = ImageHelper.downloadImage(from: nextSmallestDateProject.coverURL)
            return UpcomingProjectEntry(date: Date.now, configuration: configuration, upcomingProject: smallestDateProject, nextProject: nextSmallestDateProject, image: image, nextImage: nextImage)
        } else {
            let image = ImageHelper.downloadImage(from: allProjects[0].coverURL)
            let nextImage = ImageHelper.downloadImage(from: allProjects[1].coverURL)
            return UpcomingProjectEntry(date: Date.now, configuration: configuration, upcomingProject: allProjects[0], nextProject: allProjects[1], image: image, nextImage: nextImage)
        }
    }
    
    func randomProject(from allProjects: [Project], with configuration: WidgetTypeConfigurationIntent) -> UpcomingProjectEntry{
        let project = allProjects.randomElement()
        var nextProject = allProjects.randomElement()
        
        while project?.getUniqueProjectId() == nextProject?.getUniqueProjectId() {
            nextProject = allProjects.randomElement()
        }
        
        if let project = project, let nextProject = nextProject {
            let image = ImageHelper.downloadImage(from: project.coverURL)
            let nextImage = ImageHelper.downloadImage(from: nextProject.coverURL)
            return UpcomingProjectEntry(date: Date.now, configuration: configuration, upcomingProject: project, nextProject: nextProject, image: image, nextImage: nextImage)
        } else {
            let image = ImageHelper.downloadImage(from: allProjects[0].coverURL)
            let nextImage = ImageHelper.downloadImage(from: allProjects[1].coverURL)
            return UpcomingProjectEntry(date: Date.now, configuration: configuration, upcomingProject: allProjects[0], nextProject: allProjects[1], image: image, nextImage: nextImage)
        }
        
    }
}

struct UpcomingProjectEntry: TimelineEntry {
    let date: Date
    let configuration: WidgetTypeConfigurationIntent
    let upcomingProject: Project?
    let nextProject: Project?
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
