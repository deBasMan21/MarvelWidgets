//
//  FullscreenImageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import Kingfisher

struct FullscreenImageView: View {
    @State var url: String
    @State var imageName: String = ""
    
    @State var scale: CGFloat = 1
    @State var lastScaleValue: CGFloat = 1.0
    
    var body: some View {
        VStack {
            ZoomableScrollView {
                KFImage(URL(string: url)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(lastScaleValue)
            }
        }.navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: ShareLink(item: URL(string: url)!))
            .navigationTitle(imageName)
    }
}
