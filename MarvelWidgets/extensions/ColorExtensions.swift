//
//  ColorExtensions.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 15/02/2023.
//

import Foundation
import SwiftUI

extension Color {
    static let foregroundColor: Color = Color("ForegroundColor")
    static let backgroundColor: Color = Color("BackgroundColor")
    static let accentGray: Color = Color("customGray")
    
    func withAlphaComponent(_ alpha: CGFloat) -> Color {
        Color(uiColor: UIColor(self).withAlphaComponent(alpha))
    }
}
