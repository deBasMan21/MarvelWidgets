//
//  AccessoryCircularWidget.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 08/02/2023.
//

import SwiftUI

struct AccessoryCircularWidget: View {
    @State var entry: SmallWidgetProvider.Entry
    
    var body: some View {
        Gauge(value: 7, in: 0...100) {
            Text("hello world project")
        } currentValueLabel: {
            Text("\(Int(7))")
                .foregroundColor(Color.green)
        } minimumValueLabel: {
            Text("\(entry.nextProject?.attributes.releaseDate ?? "")")
                .foregroundColor(Color.green)
        } maximumValueLabel: {
            Text("\(entry.upcomingProject?.attributes.releaseDate ?? "")")
                .foregroundColor(Color.red)
        }
        .gaugeStyle(.accessoryCircular)
        .widgetURL(URL(string: "mcuwidgets://project/\(entry.upcomingProject?.id ?? 1)")!)
    }
}
