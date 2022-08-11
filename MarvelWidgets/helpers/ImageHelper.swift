//
//  ImageHelper.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation
import SwiftUI

class ImageHelper {
    static func downloadImage(from url: URL) -> Image {
        let data = try? Data(contentsOf: url)
        if let data = data, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(uiImage: UIImage())
        }
    }
    
    static func downloadImage(from link: String) -> Image {
        return downloadImage(from: URL(string: link)!)
    }
}
