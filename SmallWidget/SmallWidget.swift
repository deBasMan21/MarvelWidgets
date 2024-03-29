//
//  SmallWidget.swift
//  SmallWidget
//
//  Created by Bas Buijsen on 10/08/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct SmallWidgetUpcoming : View {
    @Environment(\.widgetFamily) var family
    var entry: SmallWidgetProvider.Entry

    var body: some View {
        if let project = entry.upcomingProject {
            switch family{
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
            Text("No project")
        }
    }
}

struct SmallWidget: Widget {
    let kind: String = "SmallWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: UpcomingWidgetIntent.self, provider: SmallWidgetProvider()) { entry in
            SmallWidgetUpcoming(entry: entry)
                .widgetBackground(Color.black)
        }
        .configurationDisplayName("Any MCU Project")
        .description("This widget shows a MCU project with a countdown if the project is not released yet. This widget has configuration settings to change it to your needs.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryInline, .accessoryRectangular])
        .contentMarginsDisabled()
    }
}
