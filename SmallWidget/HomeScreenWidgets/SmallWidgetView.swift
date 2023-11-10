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
    let size: CGSize
    
    let gradient = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .clear, location: 1),
                .init(color: .clear, location: 0.5),
                .init(color: .black.withAlphaComponent(0.9), location: 0),
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
    
    var body: some View {
        ZStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
                .if(showText) { view in
                    view.overlay(gradient)
                }
            
            HStack {
                VStack(alignment: .leading) {
                    if showText {
                        Spacer()
                        
                        Text(upcomingProject.attributes.title)
                            .multilineTextAlignment(.leading)
                            .shadow(color: .black, radius: 5)
                            .bold()
                            .foregroundColor(.white)
                        
                        if let string = upcomingProject.attributes.getDaysUntilRelease(withDaysString: true) {
                            Text(string)
                                .shadow(color: .black, radius: 5)
                                .font(Font.system(size: 12))
                                .foregroundColor(Color(uiColor: .lightGray))
                        }
                    }
                }
                
                Spacer()
            }.padding(5)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Image("AppIconLarge")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .cornerRadius(5)
                        .padding(7)
                }
                Spacer()
            }
        }.widgetURL(upcomingProject.getUrl())
            .frame(width: size.width, height: size.height)
    }
}
