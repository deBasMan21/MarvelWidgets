//
//  DirectorListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import SwiftUIPager
import Kingfisher

struct DirectorListView: View {
    @State var directors: [DirectorsWrapper]
    @Binding var showLoader: Bool
    
    @State var activeImageFullscreen: [String: Bool] = [:]
    
    var body: some View {
        GeometryReader { reader in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(directors) { director in
                        VStack {
                            if let imageUrl = director.attributes.imageURL {
                                NavigationLink(destination: DirectorDetailView(
                                        director: director,
                                        showLoader: $showLoader
                                    ),
                                    isActive: binding(
                                        for: imageUrl
                                    )
                                ) {
                                    EmptyView()
                                }
                                
                                CircularImageView(imageUrl: imageUrl, onTapCallback: { url in
                                    activeImageFullscreen[url] = true
                                })
                                
                                Text("\(director.attributes.firstName) \(director.attributes.lastName)")
                                    .bold()
                                    .foregroundColor(.accentColor)
                                
                                if let birthDay = director.attributes.dateOfBirth?.toDate()?.toFormattedString() {
                                    Text("\(birthDay)")
                                }
                            }
                        }.frame(width: 150)
                    }
                }.frame(minWidth: reader.size.width)
            }
        }.frame(height: 150)
    }
    
    private func binding(for key: String) -> Binding<Bool> {
        return .init(
            get: { self.activeImageFullscreen[key, default: false] },
            set: { self.activeImageFullscreen[key] = $0 })
    }
}
