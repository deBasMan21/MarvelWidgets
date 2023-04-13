//
//  AutoSizingSheet.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 04/04/2023.
//

import Foundation
import SwiftUI
import ScrollViewIfNeeded

struct AutoSizingSheet<Content: View>: View {
    var content: () -> Content
    
    @State var contentSize: CGSize = .zero
    
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            VStack {
                ScrollViewIfNeeded {
                    content()
                        .overlay(
                            GeometryReader { geo in
                                Color.clear.onAppear {
                                    contentSize = geo.size
                                }
                            }
                        )
                }
            }
        }.presentationDragIndicator(.visible)
            .presentationDetents([.height(contentSize.height + 50)])
    }
}
