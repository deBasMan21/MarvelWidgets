//
//  ImageHelper.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation
import SwiftUI
import WidgetKit

class ImageHelper {
    static func downloadImage(from url: URL, widgetFamily: WidgetFamily) -> Image {
        let data = try? Data(contentsOf: url)
        
        let widgetWidth = WidgetHelper.widgetSize(forFamily: widgetFamily).width
        if let data = data, let uiImage = UIImage(data: data)?.resized(maxWidth: widgetWidth) {
            return Image(uiImage: uiImage)
        } else {
            return Image("secret wars")
        }
    }
    
    static func downloadImage(from link: String, widgetFamily: WidgetFamily) -> Image {
        if let url = URL(string: link) {
            return downloadImage(from: url, widgetFamily: widgetFamily)
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

extension UIImage {
    func resized(maxWidth width: CGFloat) -> UIImage? {
        print("debug: width \(width)")
        // If the image is already small enough just return the image
        guard width < size.width else { return self }
        
        // Calculate the height based on the current aspect ratio
        let height = width * (size.height / size.width)
        let newSize = CGSize(width: width, height: height)
        
        // Redraw the image with the correct size
        guard let cgImage = cgImage, let colorSpace = cgImage.colorSpace else { return nil }
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let bitmapInfo = cgImage.bitmapInfo

        guard let context = CGContext(data: nil, width: Int(width), height: Int(height),
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow, space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else { return nil }
        context.interpolationQuality = .high
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        context.draw(cgImage, in: rect)

        return context.makeImage().flatMap { UIImage(cgImage: $0) }
    }
}
