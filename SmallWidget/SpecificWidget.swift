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
    let emptyProject = ProjectWrapper(id: -1, attributes: MCUProject(title: "", releaseDate: nil, postCreditScenes: nil, duration: nil, phase: .unkown, saga: .infinitySaga, overview: nil, type: .special, boxOffice: nil, createdAt: nil, updatedAt: nil, directors: nil, actors: nil, relatedProjects: nil, trailers: nil, posters: nil, seasons: nil))
    
    func placeholder(in context: Context) -> UpcomingProjectEntry {
        return UpcomingProjectEntry(date: Date(), configuration: WidgetTypeConfigurationIntent(), upcomingProject: emptyProject, nextProject: emptyProject, image: Image("secret wars"), nextImage: Image("secret wars"))
    }
    
    func getSnapshot(for configuration: WidgetTypeConfigurationIntent, in context: Context, completion: @escaping (UpcomingProjectEntry) -> Void) {
        let entry = UpcomingProjectEntry(date: Date(), configuration: WidgetTypeConfigurationIntent(), upcomingProject: emptyProject, nextProject: emptyProject, image: Image("secret wars"), nextImage: Image("secret wars"))
        completion(entry)
    }
    
    func getTimeline(for configuration: WidgetTypeConfigurationIntent, in context: Context, completion: @escaping (Timeline<UpcomingProjectEntry>) -> Void) {
        Task {
            let specificId = UserDefaults(suiteName: UserDefaultValues.suiteName)!.string(forKey: UserDefaultValues.specificSelectedProject) ?? ""
            
            var proj: ProjectWrapper? = nil
            if !specificId.isEmpty, let idAsInt = Int(specificId) {
                proj = await NewDomainService.getById(idAsInt)
            }
            
            var image: Image = Image("AppIcon")
            if let proj = proj {
                image = ImageHelper.downloadImage(from: proj.attributes.posters?.randomElement()?.posterURL ?? "")
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
