//
//  HomePageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 23/01/2024.
//

import Foundation
import SwiftUI
import Kingfisher

struct HomePageView: View {
    @State var homepage: HomepageWrapper?
    
    var body: some View {
        VStack {
            if let homepage {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(homepage.attributes.components) { component in
                            switch component {
                            case .highlight(let component): HighlightComponentView(highlightComponent: component)
                            case .text(let component): TextComponentView(textComponent: component)
                            case .youtube(let component): YoutubeComponentView(title: component.title, url: component.embedUrl)
                            case .title(let component): TitleComponentView(component: component)
                            case .horizontalList(let component): HorizontalListComponentView(component: component)
                            default: EmptyView()
                            }
                        }
                    }.padding(.horizontal, 20)
                }
            } else {
                ProgressView()
            }
        }.task {
            homepage = await HomepageService.getHomepage()
        }.refreshable {
            homepage = await HomepageService.getHomepage()
        }.showTabBar()
            .navigationTitle("Home")
    }
}
