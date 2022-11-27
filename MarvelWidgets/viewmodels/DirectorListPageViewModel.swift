//
//  DirectorListPageViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/11/2022.
//

import Foundation
import SwiftUI

extension DirectorListPageView {
    class ViewModel: ObservableObject {
        @Published var orderType: SortKeys = .nameASC
        @Published var directors: [DirectorsWrapper] = []
        let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
        
        func getDirectors() async {
            directors = await ProjectService.getDirectors()
            sortDirectors(by: orderType)
        }
        
        func sortDirectors(by type: SortKeys) {
            orderType = type
            switch type {
            case .nameASC:
                directors = directors.sorted(by: {
                    "\($0.attributes.firstName) \($0.attributes.lastName)" < "\($1.attributes.firstName) \($1.attributes.lastName)"
                })
            case .nameDESC:
                directors = directors.sorted(by: {
                    "\($0.attributes.firstName) \($0.attributes.lastName)" > "\($1.attributes.firstName) \($1.attributes.lastName)"
                })
            case .projects:
                directors = directors.sorted(by: {
                    $0.attributes.mcuProjects?.data.count ?? 0 > $1.attributes.mcuProjects?.data.count ?? 0
                })
            }
        }
    }
}
