//
//  OnboardingPageOneView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI
import UIKit

struct OnboardingPageOneView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("MCUWidgets")
                .font(.largeTitle)
                .bold()
            
            Text("Welcome to MCUWidgets! \nThe app with all the most recent MCU information and everything you need to know.")
            
            Text("In the next steps you will get information about the widgets and set up push notifications.")
        }.multilineTextAlignment(.center)
    }
}
