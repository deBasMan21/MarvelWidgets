//
//  SmallWidgetUpcomingSmallView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/08/2022.
//

import Foundation
import SwiftUI

struct SmallWidgetUpcomingSmall: View {
    let upcomingProject: Project
    let image: Image
    
    var body: some View {
        ZStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
            HStack {
                VStack {
                    Spacer()
                    
                    if let showTitle = UserDefaults(suiteName: UserDefaultValues.suiteName)!.bool(forKey: UserDefaultValues.smallWidgetShowText), showTitle {
                        Text(upcomingProject.title)
                            .multilineTextAlignment(.center)
                            .shadow(color: .black, radius: 5)
                            .font(Font.headline.weight(.bold))
                        
                        Spacer()
                        
                        if let difference = upcomingProject.releaseDate?.toDate()?.differenceInDays(from: Date.now), difference >= 0 {
                            Text("\(difference) dagen")
                                .padding(.bottom, 30)
                        }
                    }
                }.padding()
            }
        }.widgetURL(URL(string: "mcuwidgets://project/\(upcomingProject.getUniqueProjectId())")!)
    }
}
