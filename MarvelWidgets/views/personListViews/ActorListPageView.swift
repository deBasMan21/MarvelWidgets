//
//  ActorListPageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/11/2022.
//

import Foundation
import SwiftUI

struct ActorListPageView: View {
    @Binding var showLoader: Bool
    
    @State var actors: [ActorsWrapper] = []
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(actors) { actorObj in
                        NavigationLink(destination: ActorDetailView(actor: actorObj, showLoader: $showLoader)) {
                            VStack {
                                ImageSizedView(url: actorObj.attributes.imageURL ?? "")
                                
                                Text("\(actorObj.attributes.firstName) \(actorObj.attributes.lastName)")
                            }
                        }
                    }
                }
            }
        }.onAppear {
            Task {
                await getActors()
            }
        }
    }
    
    func getActors() async {
        actors = await ProjectService.getActors()
        sortActors(by: .projects)
    }
    
    private func sortActors(by type: SortKeys) {
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
    
    private enum SortKeys {
        case nameASC
        case nameDESC
        case projects
    }
}
