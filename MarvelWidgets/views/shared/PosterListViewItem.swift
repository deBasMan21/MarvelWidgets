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
            
            VStack(alignment: .leading) {
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(Font.headline.bold())
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        
                        Text(subTitle)
                            .font(.system(size: 12))
                            .foregroundColor(Color(uiColor: .lightGray))
                        
                    }.padding(7)
                    
                    Spacer()
                }
                
            }.frame(width: 150, height: 250)
        }.foregroundColor(.white)
            .shadow(color: Color(uiColor: UIColor.white.withAlphaComponent(0.3)), radius: 5)
    }
}
