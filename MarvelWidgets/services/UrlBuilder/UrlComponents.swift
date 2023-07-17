//
//  UrlComponenets.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/04/2023.
//

import Foundation

public enum UrlFilterComponents {
    case filterMovie
    case filterSerie
    case filterSpecial
    case firstUpcoming
    
    case mcuProjectFilter
    case relatedProjectFilter
    
    case emptyFilter
}

public enum UrlPopulateComponents {
    case populateNone
    case populateNormal
    case populatePosters
    case populatePersonPosters
    case populateNormalWithRelatedPosters
    case populateWidget
    case populateCollection
}
