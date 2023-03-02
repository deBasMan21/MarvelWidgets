//
//  PosterListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import SwiftUIPager
import Algorithms

struct PosterListView: View {
    @State var posters: [Poster]
    
    @State var width: CGFloat = 150
    @State var height: CGFloat = 250
    
    @State var activeImageFullscreen: [String: Bool] = [:]
    
    var body: some View {
        TabView {
            ForEach(posters.chunks(ofCount: 2).compactMap(Array.init), id: \.first!.id) { posters in
                HStack {
                    Spacer()
                    
                    OtherView(poster: posters.first, activeImageFullscreen: $activeImageFullscreen)
                    
                    Spacer()
                    
                    if let secondPoster = posters.second {
                        OtherView(poster: secondPoster, activeImageFullscreen: $activeImageFullscreen)
                        
                        Spacer()
                    }
                }.tabItem {
                    Text("Poster")
                }
            }
        }.tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 300)
    }
}

struct OtherView: View {
    @State var poster: Poster?
    @Binding var activeImageFullscreen: [String: Bool]
    
    var body: some View {
        VStack {
            if let poster = poster {
                NavigationLink(destination: FullscreenImageView(url: poster.posterURL), isActive: binding(for: poster.posterURL)) {
                    EmptyView()
                }
                
                ImageSizedView(url: poster.posterURL)
                    .onTapGesture {
                        activeImageFullscreen[poster.posterURL] = true
                    }
            }
        }
    }
    
    private func binding(for key: String) -> Binding<Bool> {
        return .init(
            get: { self.activeImageFullscreen[key, default: false] },
            set: { self.activeImageFullscreen[key] = $0 })
    }
}

extension [Poster] {
    var second: Poster? {
        if self.count > 1 {
            return self[1]
        } else {
            return nil
        }
    }
}
