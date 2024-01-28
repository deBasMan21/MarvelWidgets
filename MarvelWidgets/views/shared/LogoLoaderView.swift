//
//  LogoLoaderView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/01/2024.
//

import Foundation
import SwiftUI

struct LogoLoaderView: View {
    @State var scale: CGFloat = 1
    
    var body: some View {
        Image("AppIconLargeDark")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50)
            .cornerRadius(10)
            .scaleEffect(scale)
            .animation(.spring().repeatForever(), value: scale)
            .onAppear {
                scale = 1.5
            }
    }
}
