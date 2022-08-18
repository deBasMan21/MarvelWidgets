//
//  SaveService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/08/2022.
//

import Foundation

class SaveService {
    static func getProjectsFromUserDefaults() -> [Project] {
        let defs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
        let ids: [String] = defs.array(forKey: UserDefaultValues.savedProjectIds) as? [String] ?? []
        var projects: [Project] = []
        
        for id in ids {
            let decoder = JSONDecoder()
            let projData = defs.data(forKey: id)
            
            if let data = projData {
                if id.starts(with: "s") {
                    let proj = try? decoder.decode(Serie.self, from: data)
                    if let proj = proj {
                        projects.append(proj)
                    }
                } else if id.starts(with: "m") {
                    let proj = try? decoder.decode(Movie.self, from: data)
                    if let proj = proj {
                        projects.append(proj)
                    }
                }
            }
        }
        
        return projects
    }
    
    static func getSpecificProjectFromUserDefaults(_ id: String) -> Project? {
        let defs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
    
        var project: Project? = nil
        let decoder = JSONDecoder()
        let projData = defs.data(forKey: id)
        
        if let data = projData {
            if id.starts(with: "s") {
                let proj = try? decoder.decode(Serie.self, from: data)
                if let proj = proj {
                    project = proj
                }
            } else if id.starts(with: "m") {
                let proj = try? decoder.decode(Movie.self, from: data)
                if let proj = proj {
                    project = proj
                }
            }
        }
        
        return project
    }
}
