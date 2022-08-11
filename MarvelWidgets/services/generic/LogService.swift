//
//  LogService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

class LogService {
    static func log<T>(_ message: String, in objectType: T.Type) {
        print("\(Date.now.description) in \(objectType) with message: \(message)")
    }
}
