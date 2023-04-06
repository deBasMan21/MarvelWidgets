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
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), configuration: SpecificWidgetIntent(), upcomingProject: Placeholders.emptyProject, nextProject: Placeholders.emptyProject, image: Image("secret wars"), nextImage: Image("secret wars"))
    }

    func getSnapshot(for configuration: SpecificWidgetIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, upcomingProject: Placeholders.emptyProject, nextProject: Placeholders.emptyProject, image: Image("secret wars"), nextImage: Image("secret wars"))
        completion(entry)
    }
    
    func getProject(type: String, id: Int) async -> ProjectWrapper? {
        switch type {
        case "mcu": return await ProjectService.getById(id)
        case "other": return await ProjectService.getOtherById(id, force: true)
        default: return nil
        }
    }

    func getTimeline(for configuration: SpecificWidgetIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            var proj: ProjectWrapper? = nil
            let projects = configuration.selectedProjects ?? []
            
            if projects.count > 0 {
                let project = projects.randomElement()
                
                let idParts = project?.identifier?.split(separator: "-")
                let id = idParts?.last
                let type = idParts?.first
                
                if let type = type, let id = id, let id = Int(id) {
                    proj = await getProject(type: String(type), id: id)
                }
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
    let configuration: SpecificWidgetIntent
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
                SmallWidgetUpcomingSmall(upcomingProject: project, image: entry.image, showText: entry.configuration.ShowText == 1)
            default:
                Text("Not implemented")
            }
        } else {
            VStack(spacing: 10) {
                Text("Oh no! There is no project selected yet.")
                    .foregroundColor(Color("AccentColor"))
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text("Tap and hold this widget to select one or more projects. A random project from this list will be selected and shown.")
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct OtherWidgets: Widget {
    let kind: String = "OtherWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SpecificWidgetIntent.self, provider: Provider()) { entry in
            OtherWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Specific Projects")
        .description("This widget shows a random project from the list you can select when editing this widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
