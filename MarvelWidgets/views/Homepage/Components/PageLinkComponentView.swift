//
//  PageLinkComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/01/2024.
//

import Foundation
import SwiftUI

struct PageLinkComponentView: View {
    @Environment(\.openURLHandlerAction) private var openUrlHandler
    @State var component: PageLinkComponent
    
    var body: some View {
        VStack {
            Button(action: {
                _ = openUrlHandler?.callAsFunction(
                    URL(
                        string: InternalUrlBuilder.createUrl(entity: component.contentType.getUrlEntity(), id: component.contentTypeId, homepage: true)
                    )   
                )
            }) {
                let color = Color(hex: component.backgroundColor) ?? .accentColor
                
                HStack {
                    if component.iconName == nil {
                        Spacer()
                    }
                    
                    Text(component.text)
                        .bold()
                    
                    Spacer()
                }.padding()
                    .if(component.iconName != nil) { view in
                        view.overlay(
                            HStack {
                                Spacer()
                                
                                Image(systemName: component.iconName ?? "")
                            }.padding()
                        )
                    }.background(
                        LinearGradient(
                            stops: [
                                .init(color: color, location: 0.0),
                                .init(color: color.withAlphaComponent(0.5), location: 1.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }
        }
    }
}
