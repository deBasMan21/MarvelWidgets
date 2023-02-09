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
        Text("\(getReleaseDateString(releaseDate: project.attributes.releaseDate ?? "")) - \(project.attributes.title)")
            .widgetURL(URL(string: "mcuwidgets://project/\(project.id)")!)
    }
    
    func getReleaseDateString(releaseDate: String) -> String {
        if let difference = releaseDate.toDate()?.differenceInDays(from: Date.now), difference >= 0 {
            return "\(difference) days"
        } else {
            return ""
        }
    }
}
