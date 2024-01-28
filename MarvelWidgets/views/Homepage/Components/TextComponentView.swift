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
    @State var style: TextStyle
    
    var body: some View {
        Text(LocalizedStringKey(textComponent.text))
            .multilineTextAlignment(.center)
            .if(style.font != nil) { view in
                view.font(style.font!)
            }.if(style.color != nil) { view in
                view.foregroundStyle(style.color!)
            }
            .environment(\.openURL, OpenURLAction { url in
                return if let openUrlHandler {
                    if openUrlHandler.callAsFunction(url) {
                        .handled
                    } else { .systemAction }
                } else { .systemAction }
            })
    }
}

struct TextStyle {
    let font: Font?
    let color: Color?
}
