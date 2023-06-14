//
//  ProjectType.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

enum ProjectType: String, Codable, CaseIterable {
    case movie = "Movie"
    case serie = "Serie"
    case special = "Special"
    
    func imageString() -> String {
        switch self {
        case .movie:
            return "film.circle.fill"
        case .serie:
            return "tv.circle.fill"
        case .special:
            return "star.circle.fill"
        }
    }
}

enum ProjectSource: String, Codable, CaseIterable {
    case mcu = "MCU"
    case sony = "Sony"
    case fox = "Fox"
    case marvelTelevision = "MarvelTelevision"
    case marvelOther = "MarvelOther"
    case defenders = "Defenders"
    
    func toString() -> String {
        // Cant change the strings from the cases because they are used for decoding so this returns different strings for some cases
        switch self {
        case .marvelTelevision:
            return "Marvel Television"
        case .marvelOther:
            return "Other Marvel"
        default:
            return self.rawValue
        }
    }
    
    func getUrlTypeString() -> String {
        switch self {
        case .mcu: return "mcu"
        case .defenders, .fox, .marvelOther, .marvelTelevision, .sony: return "other"
        }
    }
}
