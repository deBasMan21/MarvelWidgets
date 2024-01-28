//
//  DividerComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 25/01/2024.
//

import Foundation
import SwiftUI

struct DividerComponentView: View {
    @State var component: DividerComponent
    
    var body: some View {
        Rectangle()
            .fill(Color(hex: component.color) ?? .accentGray)
            .frame(height: CGFloat(component.height))
            .edgesIgnoringSafeArea(.horizontal)
            .cornerRadius(10)
    }
}
