//
//  YoutubeComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 23/01/2024.
//

import Foundation
import SwiftUI

struct YoutubeComponentView: View {
    @State var title: String?
    @State var url: String
    
    var body: some View {
        VStack {
            if let title {
                Text(title)
                    .font(.title2)
            }
            
            VideoView(videoURL: url)
                .aspectRatio(16/9, contentMode: .fit)
                .cornerRadius(12)
        }
    }
}
