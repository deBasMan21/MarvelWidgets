//
//  VerticalListComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI

struct VerticalListComponentView: View {
    @Environment(\.openURLHandlerAction) private var openUrlHandler
    @State var component: VerticalListComponent
    @State var entities: [any HomepageEntity]? = nil
    @State var error: Bool = false
    
    var body: some View {
        VStack {
            if let entities {
                VStack {
                    if let title = component.title {
                        Text(title)
                            .font(.title2)
                    }
                    
                    ForEach(entities, id: \.id) { entity in
                        Button(action: {
                            _ = openUrlHandler?.callAsFunction(
                                URL(string: entity.getDestinationUrl())
                            )
                        }) {
                            VerticalListItemView(
                                imageUrl: entity.getImageUrl(),
                                title: entity.getTitle(),
                                multilineDescription: entity.getMultilineDescription()
                            )
                        }
                    }
                    
                    if component.openMoreLink {
                        HStack {
                            Spacer()
                            
                            NavigationLink(destination: Text("Whole list"), label: {
                                Label("More", systemImage: "chevron.right")
                                    .labelStyle(LabelIconStyle())
                            })
                        }.padding(.top, 10)
                    }
                }
            } else if error {
                EmptyView()
            } else {
                ProgressView()
            }
        }.task {
            if let result = await ListComponentViewHelper.fetchContentType(
                contentType: component.contentType,
                filterAndSortKey: component.filterAndSortKey ?? "",
                numberOfItems: component.numberOfItems
            ) {
                entities = result
            } else {
                error = true
            }
        }
    }
}
