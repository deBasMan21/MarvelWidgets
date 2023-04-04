//
//  PosterListViewItem.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 04/04/2023.
//

import Foundation
import SwiftUI

struct PosterListViewItem: View {
    @State var posterUrl: String
    @State var title: String
    @State var subTitle: String
    @State var showGradient: Bool = true
    
    var body: some View {
        ZStack {
            ImageSizedView(url: posterUrl, showGradient: showGradient)
            
            VStack {
                Spacer()
                
                VStack {
                    Text(title)
                        .font(Font.headline.bold())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(subTitle)
                        .font(Font.body.italic())
                    
                }
            }.padding(.horizontal, 20)
                .padding(.bottom)
        }.foregroundColor(.white)
            .shadow(color: Color(uiColor: UIColor.white.withAlphaComponent(0.3)), radius: 5)
    }
}
