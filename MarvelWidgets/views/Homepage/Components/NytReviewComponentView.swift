//
//  NytReviewComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI

struct NytReviewComponentView: View {
    @State var component: NytReviewComponent
    
    var body: some View {
        ReviewView(
            reviewTitle: component.reviewTitle,
            reviewSummary: component.reviewSummary,
            reviewCopyright: component.reviewCopyright
        )
    }
}
