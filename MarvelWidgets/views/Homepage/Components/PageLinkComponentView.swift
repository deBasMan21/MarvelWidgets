//
//  PageLinkComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/01/2024.
//

import Foundation
import SwiftUI

struct PageLinkComponentView: View {
    @State var component: PageLinkComponent
    @State var entity: (any HomepageEntity)?
    @State var error = false
    
    var body: some View {
        VStack {
            if let entity {
                NavigationLink(destination: AnyView(entity.getDestinationView())) {
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
            } else if error {
                EmptyView()
            } else {
                ProgressView()
            }
        }.task {
            entity = await ListComponentViewHelper.fetchSingleContentType(contentType: component.contentType, contentTypeId: component.contentTypeId)
            error = entity == nil
        }
    }
}
