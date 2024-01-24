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
                    VStack(spacing: 40) {
                        ForEach(homepage.attributes.components) { component in
                            switch component {
                            case .highlight(let component): 
                                HighlightComponentView(highlightComponent: component)
                                
                            case .text(let component): 
                                TextComponentView(textComponent: component)
                                
                            case .youtube(let component): 
                                YoutubeComponentView(title: component.title, url: component.embedUrl)
                                
                            case .title(let component): 
                                TitleComponentView(component: component)
                                
                            case .horizontalList(let component): 
                                HorizontalListComponentView(component: component)
                                
                            case .verticalList(let component): 
                                VerticalListComponentView(component: component)
                                
                            case .spotify(let component):
                                SpotifyComponentView(component: component)
                            
                            case .nytReview(let component):
                                NytReviewComponentView(component: component)
                                
                            case .none:
                                EmptyView()
                            }
                        }
                    }.padding(.horizontal, 20)
                }.contentMargins(.bottom, 20, for: .scrollContent)
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
