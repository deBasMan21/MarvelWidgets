//
//  HeaderWidgetComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/01/2024.
//

import Foundation
import SwiftUI

struct HeaderWidgetComponentView: View {
    @Environment(\.openURLHandlerAction) private var openUrlHandler
    @State var component: HeaderWidgetComponent
    @State var entity: (any HomepageEntity)?
    @State var loading = true
    
    var body: some View {
        VStack {
            if let entity {
                Button(action: {
                    _ = openUrlHandler?.callAsFunction(
                        URL(string: entity.getDestinationUrl())
                    )
                }) {
                    NewsItemView(
                        item: component,
                        appearingAnimation: false,
                        whiteText: true,
                        height: nil
                    ).foregroundStyle(.white)
                }
            } else if !loading {
                NewsItemView(
                    item: component,
                    appearingAnimation: false,
                    whiteText: true,
                    height: nil
                )
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
