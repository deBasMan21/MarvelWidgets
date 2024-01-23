//
//  TextComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 23/01/2024.
//

import Foundation
import SwiftUI

struct TextComponentView: View {
    @State var textComponent: TextComponent
    
    var body: some View {
        Text(LocalizedStringKey(textComponent.text))
            .multilineTextAlignment(.center)
    }
}
