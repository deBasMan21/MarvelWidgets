//
//  OnboardingPageFiveView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

struct OnboardingPageFiveView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("App Icon")
                .font(.largeTitle)
                .bold()
            
            Text("You can choose your app icon. By default the light mode is selected.")
            
            AppIconSelectView()
        }
    }
}
