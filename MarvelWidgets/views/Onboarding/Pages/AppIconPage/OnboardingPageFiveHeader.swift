//
//  OnboardingPageFourHeader.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

struct OnboardingPageFiveHeader: View {
    var body: some View {
        ZStack {
            Image("AppIconLargeDark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .cornerRadius(20)
                .offset(x: -50, y: -50)
                .shadow(color: Color.foregroundColor.withAlphaComponent(0.25), radius: 3)
            
            Image("AppIconLargeLight")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .cornerRadius(20)
                .offset(x: 50, y: 50)
                .shadow(color: Color.foregroundColor.withAlphaComponent(0.25), radius: 3)
        }
    }
}
