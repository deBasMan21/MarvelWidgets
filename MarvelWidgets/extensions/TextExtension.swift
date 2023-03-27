//
//  TextExtension.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 28/02/2023.
//

import Foundation
import SwiftUI

extension Text {
    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}
