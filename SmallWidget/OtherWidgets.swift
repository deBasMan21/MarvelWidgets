//
//  OtherWidgets.swift
//  OtherWidgets
//
//  Created by Bas Buijsen on 09/02/2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    let emptyProject = ProjectWrapper(id: -1, attributes: MCUProject(title: "", releaseDate: nil, postCreditScenes: nil, duration: nil, phase: .unkown, saga: .infinitySaga, overview: nil, type: .special, boxOffice: nil, createdAt: nil, updatedAt: nil, disneyPlusUrl: nil, directors: nil, actors: nil, relatedProjects: nil, trailers: nil, posters: nil, seasons: nil))
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), upcomingProject: emptyProject, nextProject: emptyProject, image: Image("secret wars"), nextImage: Image("secret wars"))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, upcomingProject: emptyProject, nextProject: emptyProject, image: Image("secret wars"), nextImage: Image("secret wars"))
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let specificId = UserDefaults(suiteName: UserDefaultValues.suiteName)!.string(forKey: UserDefaultValues.specificSelectedProject) ?? ""
            
            var proj: ProjectWrapper? = nil
            if !specificId.isEmpty, let idAsInt = Int(specificId) {
                proj = await ProjectService.getById(idAsInt, populate: .populateNormal)
            }
            
            var image: Image = Image("AppIcon")
            if let proj = proj {
                image = ImageHelper.downloadImage(from: proj.attributes.posters?.randomElement()?.posterURL ?? "")
            }
            
            let projEntry = SimpleEntry(date: Date.now, configuration: configuration, upcomingProject: proj, nextProject: nil, image: image, nextImage: nil)
            let timeline = Timeline(entries: [projEntry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let upcomingProject: ProjectWrapper?
    let nextProject: ProjectWrapper?
    let image: Image
    let nextImage: Image?
}

struct OtherWidgetsEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        if let project = entry.upcomingProject {
            switch family {
            case .systemMedium:
                SmallWidgetUpcomingMedium(upcomingProject: project, image: entry.image)
            case .systemSmall:
                SmallWidgetUpcomingSmall(upcomingProject: project, image: entry.image)
            default:
                Text("Not implemented")
            }
        } else {
            Text("No project \(entry.upcomingProject?.id ?? 1) \(entry.nextProject?.id ?? 1)")
        }
    }
}

struct OtherWidgets: Widget {
    let kind: String = "OtherWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            OtherWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Specific MCU Project")
        .description("This widget shows the specific project that is selected in the settings of the app. To change this go to more -> settings and choose another project.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
