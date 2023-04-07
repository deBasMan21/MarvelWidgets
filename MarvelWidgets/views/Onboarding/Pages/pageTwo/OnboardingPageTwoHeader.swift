//
//  OnboardingPageTwoHeader.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

struct OnboardingPageTwoHeader: View {
    var body: some View {
        ZStack {
            let widgetBoundsMedium = WidgetHelper.widgetSize(forFamily: .systemMedium)
            MediumWidgetView(upcomingProject: Placeholders.emptySmallProject, image: Placeholders.smallProjectImage)
                .frame(width: widgetBoundsMedium.width, height: widgetBoundsMedium.height)
                .background(Color(uiColor: UIColor.systemBackground))
                .cornerRadius(20)
                .offset(x: 50)
                .shadow(color: Color.foregroundColor.withAlphaComponent(0.25), radius: 3)
            
            let widgetBoundsSmall = WidgetHelper.widgetSize(forFamily: .systemSmall)
            SmallWidgetView(upcomingProject: Placeholders.emptyMediumProject, image: Placeholders.mediumProjectImage, showText: true)
                .frame(width: widgetBoundsSmall.width, height: widgetBoundsSmall.height)
                .cornerRadius(20)
                .offset(x: -100, y: -100)
                .shadow(color: Color.foregroundColor.withAlphaComponent(0.25), radius: 3)
        }.scaleEffect(0.75)
    }
}
