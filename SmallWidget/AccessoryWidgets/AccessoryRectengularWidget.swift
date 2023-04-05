//
//  AccessoryRectengularWidget.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 08/02/2023.
//

import SwiftUI

struct AccessoryRectengularWidget: View {
    @State var project: ProjectWrapper
    
    var body: some View {
        HStack {
            if let dateFormatted = getReleaseDateString(upcomingProject: project) {
                Text(dateFormatted)
                    .font(.system(size: 50))
                    .minimumScaleFactor(0.01)
                    .bold()
                    .frame(width: 30)
                
                Divider()
            }
            
            VStack {
                Text(project.attributes.title)
                    .multilineTextAlignment(.center)
                
                Text(project.attributes.releaseDate ?? "No release date yet")
                    .font(.system(size: 10))
                    .lineLimit(1)
            }
        }.widgetURL(URL(string: "mcuwidgets://project/\(project.attributes.type.getUrlTypeString())/\(project.id)")!)
    }
    
    func getReleaseDateString(upcomingProject: ProjectWrapper) -> String? {
        if let difference = upcomingProject.attributes.releaseDate?.toDate()?.differenceInDays(from: Date.now), difference >= 0 {
            return "\(difference)"
        } else {
            return nil
        }
    }
}
