//
//  DirectorListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/11/2022.
//

import Foundation
import SwiftUI

struct DirectorListPageView: View {
    @Binding var showLoader: Bool
    
    @State var directors: [DirectorsWrapper] = []
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(directors) { director in
                        NavigationLink(destination: DirectorDetailView(director: director, showLoader: $showLoader)) {
                            VStack {
                                ImageSizedView(url: director.attributes.imageURL ?? "")
                                
                                Text("\(director.attributes.firstName) \(director.attributes.lastName)")
                            }
                        }
                    }
                }
            }
        }.onAppear {
            Task {
                await getDirectors()
            }
        }
    }
    
    private func getDirectors() async {
        directors = await ProjectService.getDirectors()
        sortDirectors(by: .projects)
    }
    
    private func sortDirectors(by type: SortKeys) {
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
    
    private enum SortKeys {
        case nameASC
        case nameDESC
        case projects
    }
}
