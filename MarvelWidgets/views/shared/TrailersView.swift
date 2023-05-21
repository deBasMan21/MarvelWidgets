//
//  TrailersView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import Kingfisher

struct TrailersView: View {
    @State var trailers: [Trailer]
    
    var body: some View {
        VStack {
            TabView {
                ForEach(trailers, id: \.id) { trailer in
                    VStack {
                        VideoView(videoURL: trailer.youtubeLink)
                            .frame(width: 300, height: 170)
                            .cornerRadius(12)
                        
                        Text(trailer.trailerName)
                            .bold()
                            .foregroundColor(.accentColor)
                        
                        Spacer()
                    }.tabItem {
                        Text("Poster")
                    }
                }
            }.tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .frame(height: 250)
        }
    }
}
