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
    func getProjectEntry(context: Context) -> SimpleEntry {
        return SimpleEntry(
            date: Date(),
            configuration: SpecificWidgetIntent(),
            upcomingProject: Placeholders.emptyProject,
            image: Image("secret wars"),
            size: context.displaySize
        )
    }
    func placeholder(in context: Context) -> SimpleEntry {
        return getProjectEntry(context: context)
    }

    func getSnapshot(for configuration: SpecificWidgetIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(getProjectEntry(context: context))
    }
    
    func getProject(type: String, id: Int) async -> ProjectWrapper? {
        return await ProjectService.getById(id, populate: .populateWidget)
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
            
            var image: Image = Image("secret wars")
            if let proj = proj {
                image = proj.attributes.getWidgetImage(
                    widgetFamily: context.family,
                    size: context.displaySize
                )
            }
            
            let projEntry = SimpleEntry(
                date: Date.now,
                configuration: configuration,
                upcomingProject: proj,
                image: image,
                size: context.displaySize
            )
            let timeline = Timeline(entries: [projEntry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: SpecificWidgetIntent
    let upcomingProject: ProjectWrapper?
    let image: Image
    let size: CGSize
}

struct OtherWidgetsEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        if let project = entry.upcomingProject {
            switch family {
            case .systemMedium:
                MediumWidgetView(
                    upcomingProject: project,
                    image: entry.image,
                    size: entry.size
                )
                
            case .systemSmall:
                SmallWidgetView(
                    upcomingProject: project,
                    image: entry.image,
                    showText: entry.configuration.ShowText == 1,
                    size: entry.size
                )
                
            case .systemLarge:
                LargeWidgetView(
                    project: project,
                    image: entry.image,
                    size: entry.size
                )
                
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
                .widgetBackground(Color.black)
        }
        .configurationDisplayName("Specific Projects")
        .description("This widget shows a random project from the list you can select when editing this widget.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryInline, .accessoryRectangular])
        .contentMarginsDisabled()
    }
}

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *), #available(iOS 17.0, *){
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
