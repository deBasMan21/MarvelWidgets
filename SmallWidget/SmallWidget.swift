//
//  SmallWidget.swift
//  SmallWidget
//
//  Created by Bas Buijsen on 10/08/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), upcomingProject: Movie(id: 0, title: "temp", releaseDate: "", boxOffice: "", duration: 0, overview: nil, coverURL: "", trailerURL: "", directedBy: "", phase: 0, saga: .infinitySaga, chronology: 0, postCreditScenes: 0, imdbID: ""))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, upcomingProject: Movie(id: 0, title: "temp", releaseDate: "", boxOffice: "", duration: 0, overview: nil, coverURL: "", trailerURL: "", directedBy: "", phase: 0, saga: .infinitySaga, chronology: 0, postCreditScenes: 0, imdbID: ""))
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            var entries: [SimpleEntry] = []
            let upcomingProjects = await MovieService.getMoviesChronologically()
            
            entries.append(SimpleEntry(date: Date.now, configuration: configuration, upcomingProject: upcomingProjects[0]))

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let upcomingProject: Movie
}

struct SmallWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.upcomingProject.title)
    }
}

@main
struct SmallWidget: Widget {
    let kind: String = "SmallWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            SmallWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Upcoming marvel")
        .description("This widget shows the first upcoming marvel project with a countdown.")
    }
}
