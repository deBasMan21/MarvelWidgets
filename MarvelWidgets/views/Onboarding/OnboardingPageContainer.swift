//
//  OnboardingPageContainer.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

enum SpacerPosition {
    case middle
    case none
}

struct OnboardingPageContainer<Content: View, Header: View>: View {
    @State var spacerPosition: SpacerPosition
    let content: () -> Content
    let header: () -> Header
    
    init(
        spacerPosition: SpacerPosition,
        @ViewBuilder _ content: @escaping () -> Content,
        @ViewBuilder header: @escaping () -> Header
    ) {
        self.content = content
        self.header = header
        self.spacerPosition = spacerPosition
    }
    
    var body: some View {
        VStack {
            header()
            
            if spacerPosition == .middle {
                Spacer()
            }
            
            content()
                .padding(20)
        }.padding(.vertical, 100)
    }
}
