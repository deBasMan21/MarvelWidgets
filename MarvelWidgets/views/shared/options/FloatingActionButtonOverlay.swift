//
//  FloatingActionButtonOverlay.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 04/04/2023.
//

import Foundation
import SwiftUI

struct FloatingActionButtonOverlay: View {
    @State var buttons: [OptionCircleButton]
    
    @State var showAll: Bool = false
    @State var spacing: CGFloat = 20.0
    
    func getTransition(_ leadingIndex: Int, _ trailingIndex: Int) -> AnyTransition {
        .asymmetric(
            insertion: .opacity.animation(.spring().delay(0.1 * Double(leadingIndex))),
            removal: .opacity.animation(.spring().delay(0.1 * Double(trailingIndex)))
        )
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                VStack(spacing: spacing) {
                    Spacer()
                    
                    if showAll {
                        ForEach(Array(buttons.enumerated()), id: \.offset) { button in
                            button.1
                                .transition(getTransition(buttons.count - 1 - button.0, button.0))
                        }
                    }
                    
                    Image(systemName: showAll ? "xmark" : "ellipsis")
                        .multilineTextAlignment(.center)
                        .frame(width: 50, height: 50)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .onTapGesture {
                            withAnimation {
                                showAll.toggle()
                            }
                        }
                }
                .padding(20)
            }
        }
    }
}
