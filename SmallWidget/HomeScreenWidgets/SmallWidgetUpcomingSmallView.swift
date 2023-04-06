//
//  SmallWidgetUpcomingSmallView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/08/2022.
//

import Foundation
import SwiftUI

struct SmallWidgetUpcomingSmall: View {
    let upcomingProject: ProjectWrapper
    let image: Image
    let showText: Bool
    
    var body: some View {
        ZStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            HStack {
                VStack {
                    Spacer()
                    
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
                                .padding(.bottom, 30)
                                .foregroundColor(.white)
                        }
                    }
                }.padding()
            }
        }.widgetURL(URL(string: "mcuwidgets://project/\(upcomingProject.attributes.type.getUrlTypeString())/\(upcomingProject.id)")!)
    }
}
