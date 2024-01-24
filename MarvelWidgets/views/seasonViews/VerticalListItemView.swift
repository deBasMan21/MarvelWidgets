//
//  VerticalListItemView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI
import Kingfisher

struct VerticalListItemView: View {
    @State var imageUrl: String
    @State var title: String
    @State var multilineDescription: String
    
    var body: some View {
        HStack {
            KFImage(URL(string: imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(10)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(multilineDescription)
                    .foregroundColor(Color.foregroundColor)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
        }
    }
}
