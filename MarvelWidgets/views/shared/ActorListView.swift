//
//  ActorListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI

struct ActorListView: View {
    @State var actors: [ActorsWrapper]
    
    @State var width: CGFloat = 150
    @State var height: CGFloat = 250
    
    @State var activeImageFullscreen: [String: Bool] = [:]
    
    var body: some View {
        VStack {
            GeometryReader { reader in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(actors) { actor in
                            VStack {
                                if let imageUrl = actor.attributes.imageURL {
                                    NavigationLink(
                                        destination: PersonDetailView(
                                            person: actor.person
                                        )
                                    ) {
                                        CircleListItemView(
                                            imageUrl: imageUrl,
                                            title: "\(actor.attributes.firstName) \(actor.attributes.lastName)",
                                            subTitle: actor.attributes.dateOfBirth?.toDate()?.toFormattedString()
                                        )
                                    }
                                    
                                    
                                }
                            }.frame(width: 150)
                        }
                    }.frame(minWidth: reader.size.width)
                }
            }.frame(height: 150)
        }
    }
    
    private func binding(for key: String) -> Binding<Bool> {
        return .init(
            get: { self.activeImageFullscreen[key, default: false] },
            set: { self.activeImageFullscreen[key] = $0 })
    }
}
