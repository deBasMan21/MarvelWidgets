//
//  PageLinkComponent.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/01/2024.
//

import Foundation

struct PageLinkComponent: Codable, Hashable {
    let id: Int
    let contentType: CMSContentType
    let contentTypeId: Int
    let text: String
    let backgroundColor: String?
    let iconName: String?
}
