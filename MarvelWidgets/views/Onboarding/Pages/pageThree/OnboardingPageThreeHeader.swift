//
//  OnboardingPageThreeHeader.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

struct OnboardingPageThreeHeader: View {
    var body: some View {
        VStack {
            Image(systemName: "bell.badge")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
            
            ZStack {
                NotificationView(bodyText: "There is a new trailer available for \(Placeholders.emptyMediumProject.attributes.title)", image: Placeholders.mediumProjectImage)
                    .scaleEffect(0.75)
                
                NotificationView(bodyText: "\(Placeholders.emptySmallProject.attributes.title) (\(Placeholders.emptySmallProject.attributes.type.rawValue)) releases today!", image: Placeholders.smallProjectImage)
                    .scaleEffect(0.5)
                    .offset(x: 75, y: 50)
            }
        }
    }
}
