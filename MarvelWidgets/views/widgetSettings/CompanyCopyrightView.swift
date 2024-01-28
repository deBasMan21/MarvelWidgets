//
//  CompanyCopyrightView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 28/01/2024.
//

import Foundation
import SwiftUI

struct CompanyCopyrightView: View {
    @State var imageName: String
    @State var text: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 50)
                .saturation(0.0)
                .contrast(10)
                .colorMultiply(.white)
            
            Text(text)
                .font(.caption)
            
            Spacer()
        }
    }
}
