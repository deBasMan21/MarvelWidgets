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
    @State var item: NewsItemWrapper
    let height: CGFloat
    
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
            KFImage(URL(string: item.attributes.imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: height / 1.7)
                .clipped()
                .overlay(gradient)
            
            VStack {
                Text(item.attributes.title)
                    .fontWeight(.bold)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if let categories = item.attributes.categories {
                    HStack {
                        ForEach(categories.compactMap { $0.category }.prefix(3), id: \.hashValue) { category in
                            Text(category)
                                .textStyle(RedChipText())
                                .font(.system(size: 14))
                                .fixedSize(horizontal: true, vertical: false)
                        }
                    }.padding(.horizontal)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], alignment: .leading, spacing: 10) {
                    WidgetItemView(imageName: "calendar.circle.fill", title: "Releasedate", value: item.attributes.date_published.toDateFromDateTime()?.toFormattedString() ?? "")
                    
                    WidgetItemView(imageName: "person.circle.fill", title: "Author", value: item.attributes.author)
                }.padding(.horizontal)
                
                Text(item.attributes.summary)
                    .font(.system(size: 12))
                    .foregroundColor(Color(uiColor: .lightGray))
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }.padding(.top, -20)
                .padding(.horizontal)
            
            Spacer()
        }.frame(height: height)
            .scrollTransition(.animated.threshold(.visible(0.5))) { view, transition in
                view.opacity(transition.isIdentity ? 1 : 0.3)
            }
    }
}
