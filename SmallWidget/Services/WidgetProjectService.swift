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
    static func upcomingProject(from allProjects: [ProjectWrapper], with configuration: UpcomingWidgetIntent, widgetFamily: WidgetFamily) -> UpcomingProjectEntry {
        let smallestDateProject = allProjects.first
        
        let image = ImageHelper.downloadImage(
            from: smallestDateProject?.attributes.getPosterUrls(imageSize: ImageSize(size: .poster(.w500))).randomElement() ?? "",
            widgetFamily: widgetFamily
        )
        
        return UpcomingProjectEntry(
            date: Date.now,
            configuration: configuration,
            upcomingProject: smallestDateProject,
            image: image
        )
    }
    
    static func randomProject(from allProjects: [ProjectWrapper], with configuration: UpcomingWidgetIntent, widgetFamily: WidgetFamily) -> UpcomingProjectEntry {
        let project = allProjects.randomElement()
        
        if let project = project {
            let image = ImageHelper.downloadImage(
                from: project.attributes.getPosterUrls(imageSize: ImageSize(size: .poster(.w500))).randomElement() ?? "",
                widgetFamily: widgetFamily
            )
            
            return UpcomingProjectEntry(
                date: Date.now,
                configuration: configuration,
                upcomingProject: project,
                image: image
            )
        } else {
            return UpcomingProjectEntry(
                date: Date.now,
                configuration: configuration,
                upcomingProject: nil,
                image: Image("secret wars")
            )
        }
        
    }
}
