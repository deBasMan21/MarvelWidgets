//
//  ScrollViewListener.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 05/04/2023.
//

import Foundation
import SwiftUI

struct ScrollReadVStackModifier: ViewModifier {
    @Binding var scrollViewHeight: CGFloat
    @Binding var proportion: CGFloat
    var proportionName: String
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    let scrollLength = geo.size.height - scrollViewHeight
                    let rawProportion = -geo.frame(in: .named(proportionName)).minY / scrollLength
                    let proportion = min(max(rawProportion, 0), 1)
                    
                    Color.clear
                        .preference(
                            key: ScrollProportion.self,
                            value: proportion
                        )
                        .onPreferenceChange(ScrollProportion.self) { proportion in
                            withAnimation {
                                self.proportion = proportion
                            }
                        }
                }
            )
    }
    
}

struct ScrollReadScrollViewModifier: ViewModifier {
    @Binding var scrollViewHeight: CGFloat
    var proportionName: String
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear.onAppear {
                        scrollViewHeight = geo.size.height
                    }
                }
            )
            .coordinateSpace(name: proportionName)
    }
    
}

struct ScrollProportion: PreferenceKey {
    
    static let defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
}
