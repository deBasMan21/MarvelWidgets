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
                if let imageUrl = collection.attributes.backdropUrl?.replaceUrlPlaceholders(imageSize: ImageSize(size: .backdrop(.w780))) {
                    NavigationLink(
                        destination: FullscreenImageView(
                            url: imageUrl
                        )
                    ) {
                        KFImage(URL(string: imageUrl))
                            .resizable()
                            .scaledToFill()
                    }
                }
        }, content: {
            VStack(spacing: 20) {
                Text(collection.attributes.name)
                    .font(Font.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text(collection.attributes.overview)
                    .multilineTextAlignment(.center)
                
                if let projects = collection.attributes.projects?.data {
                    CollectionProjectListView(
                        inSheet: inSheet,
                        projects: projects
                    )
                }
            }.padding(.top, -60)
                .padding(.bottom, inSheet ? 0 : -30)
                .padding(.horizontal, 20)
        }).baseTintColor(Color("AccentColor"))
            .headerHeight({ _ in
                return UIScreen.main.bounds.width / (16 / 9)
            })
            .hiddenTabBar(inSheet: inSheet)
            .task {
                await getCollectionDetails()
            }
    }
    
    func getCollectionDetails() async {
        if let collection = await CollectionService.getCollectionById(id: collection.id) {
            self.collection = collection
        }
    }
}
