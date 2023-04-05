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
            return Image("secret wars")
        }
    }
    
    static func downloadImage(from link: String) -> Image {
        if let url = URL(string: link) {
            return downloadImage(from: url)
        } else {
            return Image("secret wars")
        }
        
    }
    
    static func downloadImageData(from link: String) -> Data {
        if let url = URL(string: link) {
            let data = try? Data(contentsOf: url)
            if let data = data {
                return data
            }
        }
        
        return Data()
    }
}
