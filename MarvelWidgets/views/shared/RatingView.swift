//
//  RatingView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/03/2023.
//

import Foundation
import SwiftUI

struct RatingView: View {
    @State var rating: Double
    @State var voteCount: Int
    @State var inSheet: Bool
    
    var body: some View {
        VStack {
            FiveStarView(
                rating: (rating / 2),
                color: .accentColor,
                backgroundColor: inSheet ? .black : .accentGray
            ).frame(width: 100, height: 30)
            
            Text("\(rating.roundToString(places: 1))/10 (\(voteCount) votes)")
                .font(.caption)
                .italic()
        }
    }
}

