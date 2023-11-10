//
//  ProjectService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/02/2023.
//

import Foundation
import WidgetKit
import Intents
import SwiftUI

class WidgetProjectService {
    static func upcomingProject(
        from allProjects: [ProjectWrapper],
        with configuration: UpcomingWidgetIntent,
        widgetFamily: WidgetFamily,
        size: CGSize
    ) -> UpcomingProjectEntry {
        let smallestDateProject = allProjects.first
        
        let image = ImageHelper.downloadImage(
            from: smallestDateProject?.attributes.getPosterUrls(imageSize: ImageSize(size: .poster(.w500))).randomElement() ?? "",
            size: size
        )
        
        return UpcomingProjectEntry(
            date: Date.now,
            configuration: configuration,
            upcomingProject: smallestDateProject,
            image: image,
            size: size
        )
    }
    
    static func randomProject(
        from allProjects: [ProjectWrapper],
        with configuration: UpcomingWidgetIntent,
        widgetFamily: WidgetFamily,
        size: CGSize
    ) -> UpcomingProjectEntry {
        let project = allProjects.randomElement()
        
        if let project = project {
            let image = ImageHelper.downloadImage(
                from: project.attributes.getPosterUrls(imageSize: ImageSize(size: .poster(.w500))).randomElement() ?? "",
                size: size
            )
            
            return UpcomingProjectEntry(
                date: Date.now,
                configuration: configuration,
                upcomingProject: project,
                image: image,
                size: size
            )
        } else {
            return UpcomingProjectEntry(
                date: Date.now,
                configuration: configuration,
                upcomingProject: nil,
                image: Image("secret wars"),
                size: size
            )
        }
        
    }
}
