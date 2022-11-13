//
//  PosterListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import SwiftUIPager

struct PosterListView: View {
    @State var posters: [Poster]
    
    @State var width: CGFloat = 150
    @State var height: CGFloat = 250
    
    @State var activeImageFullscreen: [String: Bool] = [:]
    @State var selectedImage: Page = .withIndex(1)
    
    var body: some View {
        Pager(
            page: selectedImage,
            data: posters,
            content: { poster in
                VStack {
                    NavigationLink(destination: FullscreenImageView(url: poster.posterURL), isActive: binding(for: poster.posterURL)) {
                        EmptyView()
                    }
                    
                    ImageSizedView(url: poster.posterURL)
                        .onTapGesture {
                            activeImageFullscreen[poster.posterURL] = true
                        }
                }
            }
        ).loopPages()
            .preferredItemSize(CGSize(width: 150, height: 250))
            .multiplePagination()
            .interactive(scale: 0.9)
            .itemSpacing(10)
            .frame(height: 250)
    }
    
    private func binding(for key: String) -> Binding<Bool> {
        return .init(
            get: { self.activeImageFullscreen[key, default: false] },
            set: { self.activeImageFullscreen[key] = $0 })
    }
}
