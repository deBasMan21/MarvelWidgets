//
//  PullToRefreshView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/08/2022.
//

import Foundation
import SwiftUI

struct PullToRefreshView: View {
    var coordinateSpaceName: String
    var onRefresh: () -> Void
    
    @State var needRefresh: Bool = false {
        didSet {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                
                ProgressView()
                
                Spacer()
            }
        }.padding(.top, -50)
    }
}
