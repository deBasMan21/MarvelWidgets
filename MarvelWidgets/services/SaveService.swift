//
//  SaveService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/08/2022.
//

import Foundation

class SaveService {
    static func getProjectsFromUserDefaults() -> [ProjectWrapper] {
        let defs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
        let ids: [String] = defs.array(forKey: UserDefaultValues.savedProjectIds) as? [String] ?? []
        var projects: [ProjectWrapper] = []
        
        for id in ids {
            let decoder = JSONDecoder()
            let projData = defs.data(forKey: id)
            
            if let data = projData {
                let proj = try? decoder.decode(ProjectWrapper.self, from: data)
                if let proj = proj {
                    projects.append(proj)
                }
            }
        }
        
        return projects
    }
    
    static func getSpecificProjectFromUserDefaults(_ id: String) -> ProjectWrapper? {
        let defs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
    
        var project: ProjectWrapper? = nil
        let decoder = JSONDecoder()
        let projData = defs.data(forKey: id)
        
        if let data = projData {
            let proj = try? decoder.decode(ProjectWrapper.self, from: data)
            if let proj = proj {
                project = proj
            }
        }
        
        return project
    }
}
