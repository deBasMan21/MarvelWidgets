//
//  StarsView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/03/2023.
//

import Foundation
import SwiftUI


public struct FiveStarView: View {
    var rating: Double
    var color: Color
    var backgroundColor: Color


    public init(
        rating: Double,
        color: Color = .red,
        backgroundColor: Color = .gray
    ) {
        self.rating = rating
        self.color = color
        self.backgroundColor = backgroundColor
    }


    public var body: some View {
        ZStack {
            BackgroundStars(backgroundColor)
            ForegroundStars(rating: rating, color: color)
        }
    }
}


struct RatingStar: View {
    var rating: CGFloat
    var color: Color
    var index: Int
    
    
    var maskRatio: CGFloat {
        let mask = rating - CGFloat(index)
        
        switch mask {
        case 1...: return 1
        case ..<0: return 0
        default: return mask
        }
    }


    init(rating: Double, color: Color, index: Int) {
        
        self.rating = CGFloat(rating)
        self.color = color
        self.index = index
    }


    var body: some View {
        GeometryReader { star in
            StarImage()
                .foregroundColor(self.color)
                .mask(
                    Rectangle()
                        .size(
                            width: star.size.width * self.maskRatio,
                            height: star.size.height
                        )
                    
                )
        }
    }
}


private struct StarImage: View {


    var body: some View {
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}


private struct BackgroundStars: View {
    var color: Color


    init(_ color: Color) {
        self.color = color
    }


    var body: some View {
        HStack {
            ForEach(0..<5) { _ in
                StarImage()
            }
        }.foregroundColor(color)
    }
}


private struct ForegroundStars: View {
    var rating: Double
    var color: Color


    init(rating: Double, color: Color) {
        self.rating = rating
        self.color = color
    }


    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                RatingStar(
                    rating: rating,
                    color: color,
                    index: index
                )
            }
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToString(places: Int) -> String {
        let divisor = pow(10.0, Double(places))
        let value = (divisor * self) / divisor
        return String(format: "%.\(places)f", value)
    }
}

struct HScrollView<Content>: View where Content: View {
    let showsIndicators: Bool
    @ViewBuilder let content: () -> Content
    
    init(showsIndicators: Bool = true, @ViewBuilder _ content: @escaping () -> Content) {
        self.showsIndicators = showsIndicators
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: showsIndicators) {
                content()
                    .frame(minWidth: geometry.size.width)
                    .fixedSize()
            }
        }
    }
}
