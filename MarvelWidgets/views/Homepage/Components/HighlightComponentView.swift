//
//  HighlightComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 23/01/2024.
//

import Foundation
import SwiftUI
import Kingfisher

struct HighlightComponentView: View {
    @State var highlightComponent: HighlightComponent
    @State var entity: (any HomepageEntity)?
    @State var error: Bool = false
    
    var body: some View {
        VStack {
            if let entity {
                CollectionsView(
                    imageUrl: entity.getBackdropUrl(),
                    titleText: highlightComponent.title ?? entity.getTitle(),
                    subTitleText: highlightComponent.subtitle ?? entity.getSubtitle(),
                    inSheet: false,
                    destinationUrl: URL(string: entity.getDestinationUrl())
                )
            } else if error {
                EmptyView()
            } else {
                ProgressView()
            }
        }.task {
            if let entity = await ListComponentViewHelper.fetchSingleContentType(contentType: highlightComponent.contentType, contentTypeId: highlightComponent.contentTypeId) {
                self.entity = entity
            } else {
                error = true
            }
        }
    }
}
