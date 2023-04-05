//
//  OptionCircleButton.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 04/04/2023.
//

import Foundation
import SwiftUI

struct OptionCircleButton: View {
    @State var visible: Bool = true
    @State var count: Int = 0
    @State var imageName: String
    var clickEvent: () -> Void
    var getFunction: (@escaping (Bool, Int) -> Void) -> Void
    
    var body: some View {
        Image(systemName: imageName)
            .multilineTextAlignment(.center)
            .frame(width: 50, height: 50)
            .background(Color.accentColor)
            .clipShape(Circle())
            .if(count > 0) { view in
                view.overlay {
                    Text("\(count)")
                        .bold()
                        .padding(10)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .offset(x: 20, y: 20)
                }
            }
            .if(!visible) { view in
                view.hidden()
            }.onTapGesture {
                clickEvent()
            }.onAppear {
                getFunction(update)
            }
    }
    
    func update(visible: Bool, count: Int) {
        self.visible = visible
        self.count = count
    }
}
