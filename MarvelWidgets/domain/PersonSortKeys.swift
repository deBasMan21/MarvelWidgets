//
//  PersonSortKeys.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/11/2022.
//

import Foundation

enum SortKeys: String, CaseIterable {
    case nameASC = "Name A-Z"
    case nameDESC = "Name Z-A"
    case dateOfBirthASC = "Date of birth Young-Old"
    case dateOfBirthDESC = "Date of birth Old-Young"
}
