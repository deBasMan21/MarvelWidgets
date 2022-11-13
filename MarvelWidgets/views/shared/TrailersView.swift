//
//  TrailersView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import SwiftUIPager
import Kingfisher

struct TrailersView: View {
    @State var trailers: [Trailer]
    
    @State var trailersIndex: Page = .first()
    
    var body: some View {
        VStack {
            Text("Trailers")
                .font(.largeTitle)
            
            Pager(
                page: trailersIndex,
                data: trailers,
                content: { trailer in
                    VStack {
                        Text(trailer.trailerName)
                            .bold()
                            .foregroundColor(.accentColor)
                        
                        VideoView(videoURL: trailer.youtubeLink)
                            .frame(width: 300, height: 170)
                            .cornerRadius(12)
                    }
                }
            )
                .preferredItemSize(CGSize(width: 280, height: 200))
                .multiplePagination()
                .itemSpacing(10)
                .interactive(rotation: true)
                .interactive(scale: 0.7)
                .frame(height: 200)
        }.padding()
    }
}
