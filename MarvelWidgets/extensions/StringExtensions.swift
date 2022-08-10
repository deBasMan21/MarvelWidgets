//
//  StringExtensions.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

extension String {
    func toDate(dateFormat: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        return formatter.date(from: self)
    }
}
