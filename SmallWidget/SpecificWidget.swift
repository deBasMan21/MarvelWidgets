//
//  SpecificWidget.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/08/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct SpecificWidgetProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> UpcomingProjectEntry {
        let project = Movie(projectId: 0, title: "Avengers: Secret Wars", boxOffice: "", releaseDate: "2025-11-07", duration: 0, overview: nil, coverURL: "", trailerURL: "", directedBy: "", phase: 0, saga: .infinitySaga, chronology: 0, postCreditScenes: 0, imdbID: "", relatedMovies: nil)
        
        return UpcomingProjectEntry(date: Date(), configuration: WidgetTypeConfigurationIntent(), upcomingProject: project, nextProject: project, image: Image("secret wars"), nextImage: Image("secret wars"))
    }
    
    func getSnapshot(for configuration: WidgetTypeConfigurationIntent, in context: Context, completion: @escaping (UpcomingProjectEntry) -> Void) {
        let project = Movie(projectId: 0, title: "Avengers: Secret Wars", boxOffice: "", releaseDate: "2025-11-07", duration: 0, overview: nil, coverURL: "", trailerURL: "", directedBy: "", phase: 0, saga: .infinitySaga, chronology: 0, postCreditScenes: 0, imdbID: "", relatedMovies: nil)
        
        let entry = UpcomingProjectEntry(date: Date(), configuration: WidgetTypeConfigurationIntent(), upcomingProject: project, nextProject: project, image: Image("secret wars"), nextImage: Image("secret wars"))
        completion(entry)
    }
    
    func getTimeline(for configuration: WidgetTypeConfigurationIntent, in context: Context, completion: @escaping (Timeline<UpcomingProjectEntry>) -> Void) {
        Task {
            let specificId = UserDefaults(suiteName: UserDefaultValues.suiteName)!.string(forKey: UserDefaultValues.specificSelectedProject) ?? ""
            
            var proj: Project? = nil
            if specificId.starts(with: "s") {
                let projId = Int(specificId.replacingOccurrences(of: "s", with: "")) ?? 0
                proj = await SeriesService.getSerieById(projId)
            } else if specificId.starts(with: "m") {
                let projId = Int(specificId.replacingOccurrences(of: "m", with: "")) ?? 0
                proj = await MovieService.getMovieById(projId)
            }
            
            var image: Image = Image("AppIcon")
            if let proj = proj {
                image = ImageHelper.downloadImage(from: proj.coverURL)
            }
            
            let projEntry = UpcomingProjectEntry(date: Date.now, configuration: configuration, upcomingProject: proj, nextProject: nil, image: image, nextImage: nil)
            let timeline = Timeline(entries: [projEntry], policy: .atEnd)
            completion(timeline)
        }
    }
    
    typealias Entry = UpcomingProjectEntry
    typealias Intent = WidgetTypeConfigurationIntent
}

struct SpecificWidgetView : View {
    @Environment(\.widgetFamily) var family
    var entry: SpecificWidgetProvider.Entry

    var body: some View {
        if let project = entry.upcomingProject {
            switch family{
            case .systemMedium:
                SmallWidgetUpcomingMedium(upcomingProject: project, image: entry.image)
            case .systemSmall:
                SmallWidgetUpcomingSmall(upcomingProject: project, image: entry.image)
            default:
                Text("Not implemented")
            }
        } else {
            Text("No project")
        }
    }
}

struct SpecificWidget: Widget {
    let kind: String = "SpecificWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: WidgetTypeConfigurationIntent.self, provider: SpecificWidgetProvider()) { entry in
            SpecificWidgetView(entry: entry)
        }
        .configurationDisplayName("Specific mcu")
        .description("This widget shows the project that you selected in the settings of the MCUWidgets app.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
