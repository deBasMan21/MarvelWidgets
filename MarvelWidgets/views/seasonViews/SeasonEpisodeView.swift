//
//  SeasonEpisodeView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI

struct SeasonEpisodeView: View {
    @State var episodes: [Episode]
    @State var source: ProjectSource
    @State var showEpisodes: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                showEpisodes = true
            }, label: {
                HStack {
                    Spacer()
                    
                    Text("Episodes (\(episodes.count))")
                    
                    Spacer()
                }.padding()
                    .overlay(
                        HStack {
                            Spacer()
                            
                            Image(systemName: "square.stack.fill")
                        }.padding()
                    )
                    .background(
                        LinearGradient(
                            stops: [
                                .init(color: Color.accentColor, location: 0.0),
                                .init(color: Color.accentColor.withAlphaComponent(0.5), location: 1.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    ).foregroundColor(.white)
                    .bold()
                    .cornerRadius(10)
            }).autosizingSheet(showSheet: $showEpisodes) {
                NavigationView {
                    SeasonEpisodeListView(episodes: episodes, source: source)
                }
            }
        }
    }
}
