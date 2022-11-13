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
    
    var body: some View {
        if #available(iOS 16.0, *) {
            VStack {
                KFImage(URL(string: url)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }.navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: ShareLink(item: URL(string: url)!))
        } else {
            VStack {
                KFImage(URL(string: url)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }.navigationBarTitleDisplayMode(.inline)
        }
    }
}
