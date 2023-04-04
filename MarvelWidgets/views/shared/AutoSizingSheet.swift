//
//  AutoSizingSheet.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 04/04/2023.
//

import Foundation
import SwiftUI

struct AutoSizingSheet<Content: View>: View {
    @State var spacing: Int
    @State var padding: Bool
    var content: () -> Content
    
    @State var size: CGSize = .zero
    
    init(spacing: Int = 0, padding: Bool = false, @ViewBuilder _ content: @escaping () -> Content) {
        self.padding = padding
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            VStack {
                content()
            }.background(
                GeometryReader { geometryProxy in
                    Color.clear
                        .onAppear {
                            size = CGSize(width: 0, height: geometryProxy.size.height)
                        }
                }
            ).if(padding) { view in
                view.padding()
            }
        }.presentationDragIndicator(.visible)
            .presentationDetents([.height(size.height + 50)])
    }
}
