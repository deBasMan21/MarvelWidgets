//
//  CollectionProjectEntity.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI

class CollectionProjectEntity: HomepageEntity {
    var id: String
    private let collection: ProjectCollection
    
    init(collection: ProjectCollection) {
        self.collection = collection
        self.id = "collection-\(collection.id)"
    }
    
    func getTitle() -> String {
        collection.attributes.name
    }
    
    func getSubtitle() -> String? {
        nil
    }
    
    func getMultilineDescription() -> String {
        collection.attributes.overview
    }
    
    func getImageUrl() -> String {
        collection.attributes.backdropUrl.replaceUrlPlaceholders(imageSize: ImageSize(size: .poster(.original)))
    }
    
    func getDestinationView() -> any View {
        CollectionPageView(collection: collection, inSheet: false)
    }
}
