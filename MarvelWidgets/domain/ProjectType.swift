//
//  ProjectType.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

enum ProjectType: String, Codable {
    case movie = "Movie"
    case serie = "Serie"
    case special = "Special"
    
    // Other types
    case sony = "Sony"
    case fox = "Fox"
    case marvelTelevision = "MarvelTelevision"
    case marvelOther = "MarvelOther"
    case defenders = "Defenders"
}
