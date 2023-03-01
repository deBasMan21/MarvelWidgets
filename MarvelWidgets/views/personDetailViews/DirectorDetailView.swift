//
//  DirectorDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 14/11/2022.
//

import Foundation
import SwiftUI
import Kingfisher
import SwiftUINavigationHeader

struct DirectorDetailView: View {
    @State var director: DirectorsWrapper
    @Binding var showLoader: Bool
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationHeaderContainer(bottomFadeout: true, headerAlignment: .top, header: {
            if let posterUrl = director.attributes.imageURL {
                NavigationLink(destination: FullscreenImageView(url: posterUrl)) {
                    KFImage(URL(string: posterUrl)!)
                        .resizable()
                        .scaledToFill()
                }
            }
        }, content: {
            VStack {
                ScrollView {
                    VStack {
                        Text("\(director.attributes.firstName) \(director.attributes.lastName)")
                            .font(Font.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        Text(director.attributes.dateOfBirth?.toDate()?.toFormattedString() ?? "Unkown")
                            .font(Font.subheadline)
                            .bold()
                            .multilineTextAlignment(.center)
                    }
                    
                    if let mcuProjectsTmp = director.attributes.mcuProjects?.data, let relatedProjects = director.attributes.relatedProjects?.data, let mcuProjects = mcuProjectsTmp + relatedProjects, mcuProjects.count > 0 {
                        VStack {
                            Text("Directed projects")
                                .font(Font.largeTitle)
                                .padding()
                            
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(mcuProjects, id: \.uuid) { project in
                                    NavigationLink {
                                        ProjectDetailView(
                                            viewModel: ProjectDetailViewModel(
                                                project: project
                                            ),
                                            showLoader: $showLoader
                                        )
                                    } label: {
                                        VStack {
                                            ImageSizedView(url: project.attributes.posters?.first?.posterURL ?? "")
                                            
                                            Text(project.attributes.title)
                                                .font(Font.headline.bold())
                                            
                                            Text(project.attributes.releaseDate?.toDate()?.toFormattedString() ?? "Unknown releasedate")
                                                .font(Font.body.italic())
                                                .foregroundColor(Color(uiColor: UIColor.label))
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }.padding()
                    }
                }.offset(x: 0, y: -50)
            }
        }).baseTintColor(Color("AccentColor"))
            .headerHeight({ _ in 500 })
    }
}
