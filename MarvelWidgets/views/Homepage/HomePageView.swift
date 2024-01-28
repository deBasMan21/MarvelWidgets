//
//  HomePageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 23/01/2024.
//

import Foundation
import SwiftUI

struct HomePageView: View {
    @State var homepage: HomepageWrapper?
    
    var body: some View {
        VStack {
            if let components = homepage?.attributes.components {
                ScrollView {
                    ComponentBuildablePageView(components: components)
                }.contentMargins(.bottom, 20, for: .scrollContent)
            } else {
                LogoLoaderView()
            }
        }.task {
            homepage = await PageService.getHomepage()
        }.refreshable {
            homepage = await PageService.getHomepage()
        }.showTabBar()
            .navigationTitle("Home")
            .toolbar(content: {
                NavigationLink(
                    destination: WidgetSettingsView()
                ) {
                    Image(systemName: "gearshape.fill")
                }
            })
    }
}
