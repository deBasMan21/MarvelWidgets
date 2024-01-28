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
                    HStack {
                        if component.iconName == nil {
                            Spacer()
                        }
                        
                        Text(component.text)
                            .bold()
                        
                        Spacer()
                        
                        if let iconName = component.iconName {
                            Image(systemName: iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    }.padding()
                        .background(Color(hex: component.backgroundColor) ?? .accentColor)
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
