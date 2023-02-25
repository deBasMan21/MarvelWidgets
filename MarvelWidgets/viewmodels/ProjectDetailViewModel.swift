//
//  ProjectDetailViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation
import SwiftUI

class ProjectDetailViewModel: ObservableObject {
    @Published var project: ProjectWrapper
    @Published var showBottomLoader = true
    
    init(project: ProjectWrapper) {
        self.project = project
        
        Task {
            await refresh(id: project.id)
        }
    }
    
    func refresh(id: Int, force: Bool = false) async {
        switch project.attributes.type {
        case .sony, .defenders, .fox, .marvelOther, .marvelTelevision:
            if let populatedProject = await getPopulatedOtherProject(id, force: force) {
                await MainActor.run {
                    withAnimation {
                        self.project = populatedProject
                    }
                }
            }
        default:
            if let populatedProject = await getPopulatedProject(id, force: force) {
                await MainActor.run {
                    withAnimation {
                        self.project = populatedProject
                    }
                }
            }
        }
        
        await MainActor.run {
            withAnimation {
                showBottomLoader = false
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
