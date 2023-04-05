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
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15){
                    ForEach(relatedProjects.data.sorted(by: {
                        $0.attributes.releaseDate ?? "" < $1.attributes.releaseDate ?? ""
                    }), id: \.uuid) { project in
                        NavigationLink {
                            ProjectDetailView(
                                viewModel: ProjectDetailViewModel(
                                    project: project
                                ),
                                inSheet: false
                            )
                        } label: {
                            VStack{
                                ImageSizedView(url: project.attributes.posters?.first?.posterURL ?? "")
                                
                                Text(project.attributes.title)
                                    .font(Font.headline.bold())
                                
                                Text(project.attributes.getReleaseDateString())
                                    .font(Font.body.italic())
                                    .foregroundColor(Color(uiColor: UIColor.label))
                            }.frame(width: 150)
                        }
                    }
                }
            }
        }.padding(.horizontal)
    }
}
