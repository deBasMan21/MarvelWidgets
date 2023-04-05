//
//  ProjectService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/02/2023.
//

import Foundation
import WidgetKit
import Intents

class WidgetProjectService {
    static func upcomingProject(from allProjects: [ProjectWrapper], with configuration: UpcomingWidgetIntent) -> UpcomingProjectEntry? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard allProjects.count == 2 else {
            return nil
        }
        
        let smallestDateProject = allProjects.first!
        let nextSmallestDateProject = allProjects.last!
        
        let image = ImageHelper.downloadImage(
            from: smallestDateProject.attributes.posters?.randomElement()?.posterURL ?? ""
        )
        
        let nextImage = ImageHelper.downloadImage(
            from: nextSmallestDateProject.attributes.posters?.randomElement()?.posterURL ?? ""
        )
        
        return UpcomingProjectEntry(
            date: Date.now,
            configuration: configuration,
            upcomingProject: smallestDateProject,
            nextProject: nextSmallestDateProject,
            image: image,
            nextImage: nextImage
        )
    }
    
    static func randomProject(from allProjects: [ProjectWrapper], with configuration: UpcomingWidgetIntent) -> UpcomingProjectEntry{
        let project = allProjects.randomElement()
        var nextProject = allProjects.randomElement()
        
        while project?.id == nextProject?.id {
            nextProject = allProjects.randomElement()
        }
        
        if let project = project, let nextProject = nextProject {
            let image = ImageHelper.downloadImage(
                from: project.attributes.posters?.randomElement()?.posterURL ?? ""
            )
            
            let nextImage = ImageHelper.downloadImage(
                from: nextProject.attributes.posters?.randomElement()?.posterURL ?? ""
            )
            
            return UpcomingProjectEntry(
                date: Date.now,
                configuration: configuration,
                upcomingProject: project,
                nextProject: nextProject,
                image: image,
                nextImage: nextImage
            )
        } else {
            let image = ImageHelper.downloadImage(
                from: allProjects[0].attributes.posters?.randomElement()?.posterURL ?? ""
            )
            
            let nextImage = ImageHelper.downloadImage(
                from: allProjects[1].attributes.posters?.randomElement()?.posterURL ?? ""
            )
            
            return UpcomingProjectEntry(
                date: Date.now,
                configuration: configuration,
                upcomingProject: allProjects[0],
                nextProject: allProjects[1],
                image: image,
                nextImage: nextImage
            )
        }
        
    }
}

enum WidgetError: Error {
    case tooSmallAmountOfProjects(amount: Int)
}
