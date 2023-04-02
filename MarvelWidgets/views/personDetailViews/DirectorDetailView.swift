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
    @State var projects: [ProjectWrapper] = []
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
                    
                    
                    if projects.count > 0 {
                        VStack {
                            Text("Directed projects")
                                .font(Font.largeTitle)
                                .padding()
                            
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(projects.sorted(by: {
                                    $0.attributes.releaseDate ?? "" < $1.attributes.releaseDate ?? ""
                                }), id: \.uuid) { project in
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
            .onAppear {
                Task {
                    if let populatedDirector = await ProjectService.getDirectorById(id: director.id) {
                        await MainActor.run {
                            withAnimation {
                                director = populatedDirector
                                
                                var projectsList: [ProjectWrapper] = []
                                if let mcuProjects = populatedDirector.attributes.mcuProjects {
                                    projectsList += mcuProjects.data
                                }
                                
                                if let relatedProjects = populatedDirector.attributes.relatedProjects {
                                    projectsList += relatedProjects.data
                                }
                                
                                self.projects = projectsList
                            }
                        }
                    }
                }
            }
    }
}
