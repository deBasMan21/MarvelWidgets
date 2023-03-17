//
//  OnboardingPageFourHeader.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

struct OnboardingPageFourHeader: View {
    var body: some View {
        Image(systemName: "checkmark.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
            .cornerRadius(20)
    }
}
