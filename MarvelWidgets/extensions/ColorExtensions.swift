//
//  ColorExtensions.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 15/02/2023.
//

import Foundation
import SwiftUI

extension Color {
    static let foregroundColor: Color = Color("CustomForegroundColor")
    static let backgroundColor: Color = Color("CustomBackgroundColor")
    static let accentGray: Color = Color("customGray")
    static let filterGray: Color = Color("FilterGray")
    
    func withAlphaComponent(_ alpha: CGFloat) -> Color {
        Color(uiColor: UIColor(self).withAlphaComponent(alpha))
    }
}

extension Color {
    init?(hex: String?) {
        guard let hexValue = hex else { return nil }
        let hex = hexValue.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
