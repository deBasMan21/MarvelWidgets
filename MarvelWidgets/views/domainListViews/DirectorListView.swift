//
//  DirectorListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import SwiftUIPager

struct DirectorListView: View {
    @State var directors: [DirectorsWrapper]
    
    @State var width: CGFloat = 150
    @State var height: CGFloat = 250
    
    @State var activeImageFullscreen: [String: Bool] = [:]
    @State var selectedImage: Page = .first()
    
    var body: some View {
        Pager(
            page: selectedImage,
            data: directors,
            content: { director in
                VStack {
                    if let imageUrl = director.attributes.imageURL {
                        NavigationLink(destination: FullscreenImageView(url: imageUrl), isActive: binding(for: imageUrl)) {
                            EmptyView()
                        }
                        
                        ImageSizedView(url: imageUrl)
                            .onTapGesture {
                                activeImageFullscreen[imageUrl] = true
                            }
                        
                        Text("\(director.attributes.firstName) \(director.attributes.lastName)")
                            .bold()
                            .foregroundColor(.accentColor)
                        
                        if let birthDay = director.attributes.dateOfBirth {
                            Text("\(birthDay)")
                        }
                    }
                }
            }
        ).loopPages()
            .preferredItemSize(CGSize(width: 150, height: 250))
            .multiplePagination()
            .interactive(scale: 0.9)
            .itemSpacing(10)
            .frame(height: 300)
    }
    
    private func binding(for key: String) -> Binding<Bool> {
        return .init(
            get: { self.activeImageFullscreen[key, default: false] },
            set: { self.activeImageFullscreen[key] = $0 })
    }
}
