//
//  ImageSizedView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import Kingfisher

struct ImageSizedView: View {
    @State var url: String
    
    @State var width: CGFloat = 150
    @State var height: CGFloat = 250
    
    var body: some View {
        KFImage(URL(string: url))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height, alignment: .center)
            .cornerRadius(12)
    }
}
