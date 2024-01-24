//
//  SpotifyComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI

struct SpotifyComponentView: View {
    @State var component: SpotifyComponent
    
    var body: some View {
        VStack {
            if let title = component.title {
                Text(title)
                    .font(.title)
            }
            
            SpotifyView(embedUrl: component.embedCode)
                .frame(height: 180)
        }
    }
}
