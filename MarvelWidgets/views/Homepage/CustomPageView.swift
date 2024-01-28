//
//  CustomPageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/01/2024.
//

import Foundation
import SwiftUI
import SwiftUINavigationHeader
import Kingfisher

struct CustomPageView: View {
    @State var pageId: Int
    @State var custompage: CustomPageWrapper?
    
    var body: some View {
        VStack {
            if let custompage, let components = custompage.attributes.components {
                if let config = custompage.attributes.parallaxConfig {
                    let imageUrl = config.imageUrl.replaceUrlPlaceholders(imageSize: ImageSize(size: .poster(.original)))
                    
                    NavigationHeaderContainer(bottomFadeout: true, headerAlignment: .center, header: {
                        NavigationLink(destination: FullscreenImageView(url: imageUrl)) {
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .scaledToFill()
                        }
                    }) {
                        ComponentBuildablePageView(components: components)
                            .padding(.top, -20)
                    }.baseTintColor(Color("AccentColor"))
                        .headerHeight({ _ in
                            return CGFloat(config.height)
                        })
                } else {
                    ScrollView {
                        ComponentBuildablePageView(components: components)
                    }.contentMargins(.bottom, 20, for: .scrollContent)
                        .refreshable {
                            self.custompage = await PageService.getPageById(id: pageId)
                        }
                }
            } else {
                LogoLoaderView()
            }
        }.hiddenTabBar()
            .if(custompage != nil && custompage?.attributes.parallaxConfig == nil) { view in
                view.navigationTitle(custompage!.attributes.title)
            }.task {
                custompage = await PageService.getPageById(id: pageId)
            }
    }
}
