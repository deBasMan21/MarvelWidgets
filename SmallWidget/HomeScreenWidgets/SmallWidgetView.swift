//
//  SmallWidgetUpcomingSmallView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/08/2022.
//

import Foundation
import SwiftUI

struct SmallWidgetView: View {
    let upcomingProject: ProjectWrapper
    let image: Image
    let showText: Bool
    
    let gradient = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color("BackgroundColor").withAlphaComponent(0.75), location: 0),
                .init(color: .clear, location: 0.2),
                .init(color: .clear, location: 0.7),
                .init(color: Color("BackgroundColor").withAlphaComponent(0.75), location: 1),
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
    
    var body: some View {
        ZStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: WidgetHelper.widgetSize(forFamily: .systemSmall).width, height: WidgetHelper.widgetSize(forFamily: .systemSmall).height)
                .clipped()
                .if(showText) { view in
                    view.overlay(gradient)
                }
            
            HStack {
                VStack {
                    if showText {
                        Text(upcomingProject.attributes.title)
                            .multilineTextAlignment(.center)
                            .shadow(color: .black, radius: 5)
                            .font(Font.headline.weight(.bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if let string = upcomingProject.attributes.getDaysUntilRelease(withDaysString: true) {
                            Text(string)
                                .shadow(color: .black, radius: 5)
                                .foregroundColor(.white)
                        }
                    }
                }
            }.padding(.vertical, 3)
        }.widgetURL(upcomingProject.getUrl())
    }
}
