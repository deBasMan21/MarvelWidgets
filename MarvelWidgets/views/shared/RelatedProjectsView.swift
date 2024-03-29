//
//  RelatedProjectsView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/03/2023.
//

import Foundation
import SwiftUI

struct RelatedProjectsView: View {
    @State var relatedProjects: RelatedProjects
    
    var body: some View {
        VStack {
            Text("Related projects")
                .font(Font.largeTitle)
                .padding(.bottom)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15){
                    ForEach(relatedProjects.data.sorted(by: {
                        $0.attributes.releaseDate ?? "" < $1.attributes.releaseDate ?? ""
                    }), id: \.id) { project in
                        NavigationLink {
                            ProjectDetailView(
                                viewModel: ProjectDetailViewModel(
                                    project: project
                                ),
                                inSheet: false
                            )
                        } label: {
                            PosterListViewItem(
                                posterUrl: project.attributes.getPosterUrls().first ?? "",
                                title: project.attributes.title,
                                subTitle: project.attributes.getReleaseDateString()
                            )
                        }
                    }
                }
            }
        }
    }
}
