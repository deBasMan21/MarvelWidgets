//
//  TextComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 23/01/2024.
//

import Foundation
import SwiftUI

struct TextComponentView: View {
    @Environment(\.openURLHandlerAction) private var openUrlHandler
    @State var textComponent: TextComponent
    
    var body: some View {
        Text(LocalizedStringKey(textComponent.text))
            .multilineTextAlignment(.center)
            .environment(\.openURL, OpenURLAction { url in
                return if let openUrlHandler {
                    if openUrlHandler.callAsFunction(url) {
                        .handled
                    } else { .systemAction }
                } else { .systemAction }
            })
    }
}
