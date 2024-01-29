//
//  CustomPageProjectEntity.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/01/2024.
//

import Foundation
import SwiftUI

struct CustomPageProjectEntity: HomepageEntity {
    private let customPage: CustomPageWrapper
    var id: String
    
    init(customPage: CustomPageWrapper) {
        self.customPage = customPage
        self.id = "page-\(customPage.id)"
    }
    
    func getTitle() -> String {
        customPage.attributes.title
    }
    
    func getSubtitle() -> String? {
        nil
    }
    
    func getMultilineDescription() -> String {
        ""
    }
    
    func getImageUrl() -> String {
        customPage.attributes.imageUrl.replaceUrlPlaceholders(imageSize: ImageSize(size: .poster(.original)))
    }
    
    func getDestinationView() -> any View {
        CustomPageView(pageId: customPage.id)
    }
}
