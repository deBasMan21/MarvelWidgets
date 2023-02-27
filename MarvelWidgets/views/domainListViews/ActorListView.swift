//
//  ActorListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import SwiftUIPager

struct ActorListView: View {
    @State var actors: [ActorsWrapper]
    @Binding var showLoader: Bool
    
    @State var width: CGFloat = 150
    @State var height: CGFloat = 250
    
    @State var activeImageFullscreen: [String: Bool] = [:]
    @State var selectedImage: Page = .first()
    
    var body: some View {
        VStack {
            Text("Actors")
                .font(.largeTitle)
            
            GeometryReader { reader in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(actors) { actor in
                            VStack {
                                if let imageUrl = actor.attributes.imageURL {
                                    NavigationLink(destination: ActorDetailView(
                                            actor: actor,
                                            showLoader: $showLoader
                                        ),
                                        isActive: binding(
                                            for: imageUrl
                                        )
                                    ) {
                                        EmptyView()
                                    }
                                    
                                    CircularImageView(imageUrl: imageUrl, onTapCallback: { url in
                                        activeImageFullscreen[url] = true
                                    })
                                    
                                    Text("\(actor.attributes.firstName) \(actor.attributes.lastName)")
                                        .bold()
                                        .foregroundColor(.accentColor)
                                    
                                    if let birthDay = actor.attributes.dateOfBirth {
                                        Text("\(birthDay)")
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
