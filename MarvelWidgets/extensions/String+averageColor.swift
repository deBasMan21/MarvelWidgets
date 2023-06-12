//
//  String+averageColor.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 04/06/2023.
//

import Foundation
import SwiftUI
import Kingfisher

extension String {
    func getColorForImageUrl() async -> Color? {
        guard let url = URL(string: self) else { return nil }
        
        do {
            let result: UIImage = try await withUnsafeThrowingContinuation { continuation in
                KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        continuation.resume(returning: value.image)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            if let uiColor = result.averageColor {
                return Color(uiColor: uiColor)
            }
        } catch let error {
            print("debug: error \(error)")
        }
        
        return nil
    }
}
