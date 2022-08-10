//
//  LogService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

class LogService {
    static func log(_ message: String, in objectType: Any) {
        print("\(Date.now.description) in \(objectType) with message: \(message)")
    }
}
