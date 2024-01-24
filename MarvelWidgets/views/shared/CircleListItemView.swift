//
//  CircleListItemView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI

struct CircleListItemView: View {
    @State var imageUrl: String
    @State var title: String
    @State var subTitle: String?
    
    var body: some View {
        VStack {
            CircularImageView(imageUrl: imageUrl)
            
            Text(title)
                .bold()
                .foregroundColor(.accentColor)
            
            if let subTitle {
                Text("\(subTitle)")
                    .foregroundColor(.foregroundColor)
            }
        }.frame(maxWidth: 150)
    }
}
