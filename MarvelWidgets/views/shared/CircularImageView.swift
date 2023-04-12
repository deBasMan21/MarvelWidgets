//
//  CircularImageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/02/2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct CircularImageView: View {
    @State var imageUrl: String
    
    var body: some View {
        KFImage(URL(string: imageUrl)!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .clipShape(Circle())
    }
}
