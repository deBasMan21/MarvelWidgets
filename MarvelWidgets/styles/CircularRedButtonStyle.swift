//
//  CircularRedButtonStyle.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

struct CircularRedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 50, height: 50)
            .foregroundColor(Color.white)
            .background(Color.accentColor)
            .clipShape(Circle())
    }
}
