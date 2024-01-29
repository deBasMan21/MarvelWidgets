//
//  ImageSize.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/07/2023.
//

import Foundation

class ImageSize {
    let sizeString: String
    
    init(size: ImageSizeWrapper) {
        switch size {
        case .backdrop(let backdrop):
            self.sizeString = backdrop.rawValue
        case .poster(let poster):
            self.sizeString = poster.rawValue
        case .still(let still):
            self.sizeString = still.rawValue
        }
    }
    
    enum ImageSizeWrapper {
        case backdrop(BackdropSize)
        case poster(PosterSize)
        case still(StillSize)
    }
    
    enum BackdropSize: String {
        case original = "original"
        case w1280 = "w1280"
        case w780 = "w780"
        case w300 = "w300"
    }
    
    enum PosterSize: String {
        case original = "original"
        case w780 = "w780"
        case w500 = "w500"
        case w342 = "w342"
        case w185 = "w185"
        case w154 = "w154"
        case w92 = "w92"
    }
    
    enum StillSize: String {
        case original = "original"
        case w300 = "w300"
        case w185 = "w185"
        case w92 = "w92"
    }
}
