//
//  OnboardingPageOneHeader.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

struct OnboardingPageOneHeader: View {
    var body: some View {
        VStack {
            Image("AppIconLarge")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .cornerRadius(20)
        }
    }
}
