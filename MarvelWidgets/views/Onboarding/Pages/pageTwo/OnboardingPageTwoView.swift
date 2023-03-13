//
//  OnboardingPageTwoView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

struct OnboardingPageTwoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Widgets")
                .font(.largeTitle)
                .bold()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("The MCUWidgets app has several types of homescreen and lockscreen widgets. There are two types of content for the widgets available. These are \"Any MCU Project\" and \"Specific MCU Project\".")
                    
                    Text("The \"Any MCU Project\" widget can be used to display the first upcoming or a random MCU Project.")
                    
                    Text("The \"Specific MCU Project\" widget can be used to display one specific project which can be selected in the settings of the MCUWidgets app.")
                }
            }
        }.multilineTextAlignment(.center)
    }
}
