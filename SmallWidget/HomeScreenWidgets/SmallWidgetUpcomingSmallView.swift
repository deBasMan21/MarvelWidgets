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
    
    var body: some View {
        ZStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
            HStack {
                VStack {
                    Spacer()
                    
                    if let showTitle = UserDefaults(suiteName: UserDefaultValues.suiteName)?.bool(forKey: UserDefaultValues.smallWidgetShowText), showTitle {
                        Text(upcomingProject.attributes.title)
                            .multilineTextAlignment(.center)
                            .shadow(color: .black, radius: 5)
                            .font(Font.headline.weight(.bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if let difference = upcomingProject.attributes.releaseDate?.toDate()?.differenceInDays(from: Date.now), difference >= 0 {
                            Text("\(difference) dagen")
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
