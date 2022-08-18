//
//  ProjectDetailViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation

class ProjectDetailViewModel: ObservableObject {
    @Published var project: Project
    @Published var movie: Movie?
    @Published var bookmarkString: String = "bookmark"
    
    init(project: Project) {
        self.project = project
    }
    
    func setIsSavedIcon(for proj: Project) {
        let userDefs = UserDefaults(suiteName: UserDefaultValues.suiteName)!

        if userDefs.data(forKey: proj.getUniqueProjectId()) != nil {
            bookmarkString = "bookmark.fill"
        } else {
            bookmarkString = "bookmark"
        }
    }
    
    func toggleSaveProject(_ proj: Project) {
        let userDefs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
        var savedIds: [String] = userDefs.array(forKey: UserDefaultValues.savedProjectIds) as? [String] ?? []

        if userDefs.data(forKey: proj.getUniqueProjectId()) != nil {
            if let indexValue = savedIds.firstIndex(of: proj.getUniqueProjectId()), let index = indexValue.codingKey.intValue {
                savedIds.remove(at: index)
            }
            
            userDefs.set(savedIds, forKey: UserDefaultValues.savedProjectIds)
            userDefs.set(nil, forKey: proj.getUniqueProjectId())
        } else {
            let dataObj: Data? = proj.toData()
            savedIds.append(proj.getUniqueProjectId())
            
            userDefs.set(dataObj, forKey: proj.getUniqueProjectId())
            userDefs.set(savedIds, forKey: UserDefaultValues.savedProjectIds)
        }
        setIsSavedIcon(for: proj)
    }
    
    func getMovieDetails() async {
        _ = await MainActor.run {
            Task {
                movie = await MovieService.getMovieById(project.projectId)
            }
        }
    }
}
