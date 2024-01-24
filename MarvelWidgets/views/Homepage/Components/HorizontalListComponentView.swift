//
//  HorizontalListComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI

struct HorizontalListComponentView: View {
    @State var component: HorizontalListComponent
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
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(entities, id: \.id) { entity in
                                NavigationLink(
                                    destination: AnyView(entity.getDestinationView())
                                ) {
                                    switch component.viewType {
                                    case .poster:
                                        PosterListViewItem(
                                            posterUrl: entity.getImageUrl(),
                                            title: entity.getTitle(),
                                            subTitle: entity.getSubtitle(),
                                            showGradient: true
                                        )
                                    case .circle:
                                        CircleListItemView(
                                            imageUrl: entity.getImageUrl(),
                                            title: entity.getTitle(),
                                            subTitle: entity.getSubtitle()
                                        )
                                    }
                                }
                            }
                        }
                    }.scrollClipDisabled()
                        .scrollIndicators(.hidden)
                    
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
