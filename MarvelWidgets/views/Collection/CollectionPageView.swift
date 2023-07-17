//
//  CollectionPageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 17/07/2023.
//

import Foundation
import SwiftUI
import Kingfisher
import SwiftUINavigationHeader

struct CollectionPageView: View {
    @State var collection: ProjectCollection
    @State var inSheet: Bool
    
    var body: some View {
        NavigationHeaderContainer(
            bottomFadeout: true,
            headerAlignment: .top,
            header: {
            NavigationLink(
                destination: FullscreenImageView(
                    url: collection.attributes.getBackdropUrl()
                )
            ) {
                KFImage(URL(string: collection.attributes.getBackdropUrl())!)
                    .resizable()
                    .scaledToFill()
            }
        }, content: {
            VStack(spacing: 20) {
                Text(collection.attributes.name)
                    .font(Font.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text(collection.attributes.overview)
                    .multilineTextAlignment(.center)
                
                CollectionProjectListView(
                    collectionId: collection.id,
                    inSheet: inSheet
                )
            }.padding(.top, -60)
                .padding(.bottom, inSheet ? 0 : -30)
                .padding(.horizontal, 20)
        }).baseTintColor(Color("AccentColor"))
            .headerHeight({ _ in
                return UIScreen.main.bounds.width / (16 / 9)
            })
            .hiddenTabBar(inSheet: inSheet)
    }
}
