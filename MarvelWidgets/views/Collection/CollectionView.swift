//
//  CollectionView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 17/07/2023.
//

import Kingfisher
import SwiftUI

struct CollectionsView: View {
    @State var collection: ProjectCollection
    @State var inSheet: Bool
    
    var body: some View {
        NavigationLink(
            destination: CollectionPageView(
                collection: collection,
                inSheet: inSheet
            )
        ) {
            ZStack {
                KFImage(URL(string: collection.attributes.getBackdropUrl(size: ImageSize(size: .backdrop(.w780)))))
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fill)
                    .overlay {
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    .white.withAlphaComponent(0),
                                    .black.withAlphaComponent(0.75)
                                ]
                            ),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    }
                    
                VStack {
                    Spacer()
                    
                    Text("Part of")
                        .font(.caption)
                    
                    Text(collection.attributes.name)
                        .font(.title2)
                        .bold()
                }.padding(.bottom, 5)
            }.foregroundColor(.white)
                .cornerRadius(10)
                .clipped()
                .shadow(color: Color(uiColor: UIColor.white.withAlphaComponent(0.2)), radius: 10)
        }
    }
}
