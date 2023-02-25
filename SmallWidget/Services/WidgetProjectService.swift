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
    static func upcomingProject(from allProjects: [ProjectWrapper], with configuration: WidgetTypeConfigurationIntent) -> UpcomingProjectEntry? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard allProjects.count == 2 else {
            return nil
        }
        
        let smallestDateProject = allProjects.first!
        let nextSmallestDateProject = allProjects.last!
        
//        let proj = allProjects
//            .map({ proj in
//                let date = formatter.date(
//                    from: proj.attributes.releaseDate ?? "2000-01-01"
//                ) ?? Date.now.addingTimeInterval(-60 * 60 * 24 * 1000)
//
//                return (proj, date)
//            }).filter({ tuple in
//                tuple.1 > Date.now
//            }).sorted(by: { $0.1 < $1.1 })
//            .prefix(2)
//
//        for (index, projItem) in proj.enumerated() {
//            if index == 0 { smallestDateProject = projItem.0 }
//            else if index == 1 { nextSmallestDateProject = projItem.0 }
//        }
        
//        if let smallestDateProject = smallestDateProject, let nextSmallestDateProject = nextSmallestDateProject {
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
//        }
//        else {
//            let image = ImageHelper.downloadImage(
//                from: allProjects[0].attributes.posters?.randomElement()?.posterURL ?? ""
//            )
//
//            let nextImage = ImageHelper.downloadImage(
//                from: allProjects[1].attributes.posters?.randomElement()?.posterURL ?? ""
//            )
//
//            return UpcomingProjectEntry(
//                date: Date.now,
//                configuration: configuration,
//                upcomingProject: allProjects[0],
//                nextProject: allProjects[1],
//                image: image,
//                nextImage: nextImage
//            )
//        }
    }
    
    static func randomProject(from allProjects: [ProjectWrapper], with configuration: WidgetTypeConfigurationIntent) -> UpcomingProjectEntry{
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
