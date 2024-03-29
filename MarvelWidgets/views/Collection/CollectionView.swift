//
//  CollectionView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 17/07/2023.
//

import Kingfisher
import SwiftUI

struct CollectionsView: View {
    @Environment(\.openURLHandlerAction) private var openUrlHandler
    @State var imageUrl: String
    @State var titleText: String?
    @State var subTitleText: String?
    @State var inSheet: Bool
    var destinationUrl: URL?
    
    var body: some View {
        Button(action: {
            _ = openUrlHandler?.callAsFunction(destinationUrl)
        }) {
            ZStack {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 40, height: (UIScreen.main.bounds.width - 40) * (9/16), alignment: .top)
                    .overlay {
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    .white.withAlphaComponent(0),
                                    .black.withAlphaComponent(0.75)
                                ]
                            ),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    }
                
                if let titleText {
                    VStack {
                        Spacer()
                        
                        if let subTitleText {
                            Text(subTitleText)
                                .font(.caption)
                        }
                        
                        Text(titleText)
                            .font(.title2)
                            .bold()
                    }.padding(.bottom, 5)
                }
            }.foregroundColor(.white)
                .cornerRadius(10)
                .clipped()
                .shadow(color: Color(uiColor: UIColor.white.withAlphaComponent(0.2)), radius: 10)
        }
    }
}
