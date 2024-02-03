//
//  HomepageEntity.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI

protocol HomepageEntity: Identifiable {
    var id: String { get }
    func getTitle() -> String
    func getSubtitle() -> String?
    func getMultilineDescription() -> String
    func getImageUrl() -> String
    func getBackdropUrl() -> String
    func getDestinationUrl() -> String
}

extension HomepageEntity {
    func getBackdropUrl() -> String {
        getImageUrl()
    }
}
