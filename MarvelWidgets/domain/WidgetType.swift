//
//  WidgetType.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

enum WidgetType: String, CaseIterable {
    case all = "all"
    case movies = "movies"
    case series = "series"
    case special = "special"
    case saved = "saved"
    
    static func getFromIndex(_ index: Int) -> WidgetType{
        switch index{
        case 0, 1:
            return .all
        case 2:
            return .movies
        case 3:
            return .series
        case 4:
            return .saved
        default:
            return .all
        }
    }
}
