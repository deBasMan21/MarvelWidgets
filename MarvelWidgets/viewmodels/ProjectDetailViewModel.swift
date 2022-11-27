//
//  ProjectDetailViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation

class ProjectDetailViewModel: ObservableObject {
    @Published var project: ProjectWrapper
    @Published var bookmarkString: String = "bookmark"
    
    init(project: ProjectWrapper) {
        self.project = project
        
        Task {
            await refresh(id: project.id)
        }
    }
    
    func setIsSavedIcon(for proj: ProjectWrapper) {
        let userDefs = UserDefaults(suiteName: UserDefaultValues.suiteName)!

        if userDefs.data(forKey: "\(proj.id)") != nil {
            bookmarkString = "bookmark.fill"
        } else {
            bookmarkString = "bookmark"
        }
    }
    
    func toggleSaveProject(_ proj: ProjectWrapper) {
        let userDefs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
        var savedIds: [String] = userDefs.array(forKey: UserDefaultValues.savedProjectIds) as? [String] ?? []

        if userDefs.data(forKey: "\(proj.id)") != nil {
            if let indexValue = savedIds.firstIndex(of: "\(proj.id)"), let index = indexValue.codingKey.intValue {
                savedIds.remove(at: index)
            }
            
            userDefs.set(savedIds, forKey: UserDefaultValues.savedProjectIds)
            userDefs.set(nil, forKey: "\(proj.id)")
        } else {
            let dataObj: Data? = proj.toData()
            savedIds.append("\(proj.id)")
            
            userDefs.set(dataObj, forKey: "\(proj.id)")
            userDefs.set(savedIds, forKey: UserDefaultValues.savedProjectIds)
        }
        setIsSavedIcon(for: proj)
    }
    
    func refresh(id: Int, force: Bool = false) async {
        switch project.attributes.type {
        case .sony, .defenders, .fox, .marvelOther, .marvelTelevision:
            if let populatedProject = await getPopulatedOtherProject(id, force: force) {
                await MainActor.run {
                    self.project = populatedProject
                }
            }
        default:
            if let populatedProject = await getPopulatedProject(id, force: force) {
                await MainActor.run {
                    self.project = populatedProject
                }
            }
        }
        
    }
    
    func getPopulatedProject(_ id: Int, force: Bool) async -> ProjectWrapper? {
        return await ProjectService.getById(id, force: force)
    }
    
    func getPopulatedOtherProject(_ id: Int, force: Bool) async -> ProjectWrapper? {
        return await ProjectService.getOtherById(id, force: force)
    }
}
