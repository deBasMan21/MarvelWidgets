//
//  WidgetPreviewView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/08/2022.
//

import SwiftUI

struct WidgetPreviewView: View {
    @Binding var project: ProjectWrapper?
    
    var body: some View {
        if let project = project {
            VStack {
                Text("Previews:")
                    .font(Font.headline.bold())
                
                VStack(spacing: 20) {
                    VStack {
                        let widgetBounds = WidgetHelper.widgetSize(forFamily: .systemSmall)
                        SmallWidgetUpcomingSmall(upcomingProject: project, image: ImageHelper.downloadImage(from: project.attributes.posters?.randomElement()?.posterURL ?? ""))
                            .frame(width: widgetBounds.width, height: widgetBounds.height)
                                .cornerRadius(20)
                    }
                    
                    VStack {
                        let widgetBounds = WidgetHelper.widgetSize(forFamily: .systemMedium)
                        SmallWidgetUpcomingMedium(upcomingProject: project, image: ImageHelper.downloadImage(from: project.attributes.posters?.randomElement()?.posterURL ?? ""))
                            .frame(width: widgetBounds.width, height: widgetBounds.height)
                                .background(Color(uiColor: UIColor.systemBackground))
                                .cornerRadius(20)
                    }
                }.shadow(color: Color(uiColor: UIColor.label), radius: 5, x: 0, y: 0)
            }
        } else {
            EmptyView()
        }
    }
}
