//
//  ReviewView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/03/2023.
//

import Foundation
import SwiftUI

struct ReviewView: View {
    @State var reviewTitle: String
    @State var reviewSummary: String
    @State var reviewCopyright: String
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 25) {
                VStack(spacing: 5) {
                    Text(reviewTitle)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Text(reviewSummary)
                        .multilineTextAlignment(.center)
                        .font(.caption)
                }
                
                Image("nytLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
            }
            
            Text(reviewCopyright)
                .font(.system(size: 7))
        }
    }
}
