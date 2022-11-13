//
//  ActorListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import SwiftUIPager

struct ActorListView: View {
    @State var actors: [ActorsWrapper]
    
    @State var width: CGFloat = 150
    @State var height: CGFloat = 250
    
    @State var activeImageFullscreen: [String: Bool] = [:]
    @State var selectedImage: Page = .first()
    
    var body: some View {
        Pager(
            page: selectedImage,
            data: actors,
            content: { actorItem in
                VStack {
                    if let imageUrl = actorItem.attributes.imageURL {
                        NavigationLink(destination: FullscreenImageView(url: imageUrl, imageName: "\(actorItem.attributes.firstName) \(actorItem.attributes.lastName)"), isActive: binding(for: imageUrl)) {
                            EmptyView()
                        }
                        
                        ImageSizedView(url: imageUrl)
                            .onTapGesture {
                                activeImageFullscreen[imageUrl] = true
                            }
                        
                        Text("\(actorItem.attributes.firstName) \(actorItem.attributes.lastName)")
                            .bold()
                            .foregroundColor(.accentColor)
                        
                        if let birthDay = actorItem.attributes.dateOfBirth {
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
