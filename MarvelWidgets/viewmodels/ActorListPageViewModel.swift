//
//  ActorListPageViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/11/2022.
//

import Foundation
import SwiftUI

extension ActorListPageView {
    class ViewModel: ObservableObject {
        @Published var orderType: SortKeys = .nameASC
        
        @Published var actors: [ActorsWrapper] = []
        let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
        
        func getActors() async {
            actors = await ProjectService.getActors()
            sortActors(by: orderType)
        }
        
        func sortActors(by type: SortKeys) {
            orderType = type
            switch type {
            case .nameASC:
                actors = actors.sorted(by: {
                    "\($0.attributes.firstName) \($0.attributes.lastName)" < "\($1.attributes.firstName) \($1.attributes.lastName)"
                })
            case .nameDESC:
                actors = actors.sorted(by: {
                    "\($0.attributes.firstName) \($0.attributes.lastName)" > "\($1.attributes.firstName) \($1.attributes.lastName)"
                })
            case .projects:
                actors = actors.sorted(by: {
                    $0.attributes.mcuProjects?.data.count ?? 0 > $1.attributes.mcuProjects?.data.count ?? 0
                })
            }
        }
    }
}
