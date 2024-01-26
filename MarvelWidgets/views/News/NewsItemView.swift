//
//  NewsItemView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 21/01/2024.
//

import Foundation
import SwiftUI
import Kingfisher

struct NewsItemView: View {
    @State var item: HeaderWidgetComponent
    @State var appearingAnimation: Bool
    @State var whiteText: Bool
    let height: CGFloat?
    
    private let gradient = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .black, location: 0.0),
                .init(color: .clear, location: 0.2)
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
    
    var body: some View {
        VStack {
            KFImage(URL(string: item.imageUrl.replaceUrlPlaceholders(imageSize: ImageSize(size: .poster(.original)))))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .if(height != nil) { view in
                    view.frame(height: height! / 1.7)
                }.if(height == nil) { view in
                    view.frame(height: (UIScreen.main.bounds.width) * (9/16), alignment: .top)
                }
                .clipped()
                .overlay(gradient)
            
            VStack {
                Text(item.title)
                    .fontWeight(.bold)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if let categories = item.categories {
                    HStack {
                        ForEach(categories.compactMap { $0.category }.prefix(3), id: \.hashValue) { category in
                            Text(category)
                                .textStyle(RedChipText())
                                .font(.system(size: 14))
                                .fixedSize(horizontal: true, vertical: false)
                        }
                    }.padding(.horizontal)
                }
                
                if let gridItems = item.gridItems {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], alignment: .leading, spacing: 10) {
                        ForEach(gridItems, id: \.title) { item in
                            WidgetItemView(imageName: item.iconName, title: item.title, value: item.value)
                        }
                    }.padding(.horizontal)
                }
                
                if let description = item.description {
                    TextComponentView(
                        textComponent: TextComponent(id: 1, text: description),
                        style: TextStyle(
                            font: whiteText ? nil : .system(size: 12),
                            color: whiteText ? .white : Color(uiColor: .lightGray)
                        )
                    ).padding(.top, 4)
                }
            }.padding(.top, -20)
                .padding(.horizontal)
            
            Spacer()
        }.frame(height: height)
            .if(appearingAnimation) { view in
                view.scrollTransition(.animated.threshold(.visible(0.5))) { view, transition in
                    view.opacity(transition.isIdentity ? 1 : 0.3)
                }
            }
    }
}
