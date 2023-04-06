//
//  AccessoryInlineWidget.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 08/02/2023.
//

import SwiftUI

struct AccessoryInlineWidget: View {
    @State var project: ProjectWrapper
    
    var body: some View {
        Text("\(project.attributes.getDaysUntilRelease(withDaysString: true) ?? "") - \(project.attributes.title)")
            .widgetURL(URL(string: "mcuwidgets://project/\(project.attributes.type.getUrlTypeString())/\(project.id)")!)
    }
}
