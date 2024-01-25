//
//  HomepageProjectEntity.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI

class HomepageProjectEntity: HomepageEntity {
    var id: String
    private let project: ProjectWrapper
    
    init(project: ProjectWrapper) {
        self.project = project
        self.id = "project-\(project.id)"
    }
    
    func getTitle() -> String {
        project.attributes.title
    }
    
    func getSubtitle() -> String? {
        project.attributes.releaseDate
    }
    
    func getMultilineDescription() -> String {
        "\(project.attributes.getReleaseDateString())\nType: \(project.attributes.type.rawValue)\nSource: \(project.attributes.source.rawValue)"
    }
    
    func getImageUrl() -> String {
        project.attributes.getPosterUrls().first ?? ""
    }
    
    func getBackdropUrl() -> String {
        project.attributes.getBackdropUrl() ?? getImageUrl()
    }
    
    func getDestinationView() -> any View {
        ProjectDetailView(viewModel: ProjectDetailViewModel(project: self.project), inSheet: false)
    }
}
