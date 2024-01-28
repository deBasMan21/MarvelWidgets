//
//  HeaderWidgetComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/01/2024.
//

import Foundation
import SwiftUI

struct HeaderWidgetComponentView: View {
    @State var component: HeaderWidgetComponent
    @State var entity: (any HomepageEntity)?
    @State var loading = true
    
    var body: some View {
        VStack {
            if let entity {
                NavigationLink(destination: AnyView(entity.getDestinationView())) {
                    NewsItemView(item: component, appearingAnimation: false, whiteText: true, height: nil)
                        .foregroundStyle(.white)
                }
            } else if !loading {
                NewsItemView(item: component, appearingAnimation: false, whiteText: true, height: nil)
            } else {
                ProgressView()
            }
        }.task {
            if let contentType = component.contentType,
                let contentTypeId = component.contentTypeId,
                let entity = await ListComponentViewHelper.fetchSingleContentType(contentType: contentType, contentTypeId: contentTypeId) {
                self.entity = entity
            } else {
                loading = false
            }
        }
        
    }
}
