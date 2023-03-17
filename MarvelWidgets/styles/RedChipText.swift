//
//  RedChipText.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

struct RedChipText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(2)
            .padding(.horizontal, 7)
            .background(Color.accentColor.withAlphaComponent(0.2))
            .foregroundColor(.white)
            .cornerRadius(20)
    }
}
