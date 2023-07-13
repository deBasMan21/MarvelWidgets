//
//  StringExtensions.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation
import SwiftUI
import UIKit

extension String {
    func toDate(dateFormat: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        return formatter.date(from: self)
    }
    
    func toMoney() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let intFromString = Int(self) ?? -1
        let string = formatter.string(from: NSNumber(value: intFromString)) ?? ""
        return "$\(string)"
    }
    
    func replaceUrlPlaceholders(imageSize: ImageSize) -> String {
        var url = self
        url.replace("[INSERT_SIZE]", with: imageSize.sizeString)
        
        return url
    }
}

extension Int {
    func toMoney() -> String {
        return "\(self)".toMoney()
    }
}
