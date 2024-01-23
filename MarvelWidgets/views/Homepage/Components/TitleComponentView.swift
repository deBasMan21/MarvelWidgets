//
//  TitleComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 23/01/2024.
//

import Foundation
import SwiftUI

struct TitleComponentView: View {
    @State var component: TitleComponent
    
    var body: some View {
        Text(component.title)
            .font(.title)
    }
}
