//
//  ProjectDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import SwiftUI
import Kingfisher

struct ProjectDetailView: View {
    @StateObject var viewModel: ProjectDetailViewModel
    @Binding var shouldStopReload: Bool
    
    var body: some View {
        ScrollView {
            VStack{
                HStack(alignment: .top) {
                    KFImage(URL(string: viewModel.project.attributes.posters?.first?.posterURL ?? "")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, alignment: .center)
                        .cornerRadius(12)
                        .padding(.trailing, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading) {
                            Text("**Director**")
                            if let director = viewModel.project.attributes.directors?.data.map({ director in
                                return "\(director.attributes.firstName) \(director.attributes.lastName)"
                                
                            }).joined(separator: ", "), !director.isEmpty {
                                Text(director)
                            } else {
                                Text("No director confirmed")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("**Release date**")
                            Text(viewModel.project.attributes.releaseDate ?? "No release date set")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("**Phase \(viewModel.project.attributes.phase.rawValue)**")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("**\(viewModel.project.attributes.saga.rawValue)**")
                        }
                    }
                    
                    Spacer()
                }
                
                if let overview = viewModel.project.attributes.overview {
                    Text("Overview")
                        .font(Font.largeTitle)
                        .padding()
                    
                    Text(overview)
                        .multilineTextAlignment(.center)
                }
                
                if let trailers = viewModel.project.attributes.trailers {
                    ForEach(trailers, id: \.youtubeLink) { trailer in
                        Text(trailer.trailerName)
                            .font(Font.largeTitle)
                            .padding()
                        
                        VideoView(videoURL: trailer.youtubeLink)
                            .frame(height: 200)
                            .cornerRadius(12)
                    }
                }
                
                if let relatedProjects = viewModel.project.attributes.relatedProjects {
                    Text("Related projects")
                        .font(Font.largeTitle)
                        .padding()
                    
                    VStack(spacing: 15){
                        ForEach(relatedProjects.data, id: \.uuid) { project in
                            NavigationLink {
                                ProjectDetailView(viewModel: ProjectDetailViewModel(project: project), shouldStopReload: $shouldStopReload)
                            } label: {
                                VStack{
                                    Text(project.attributes.title)
                                        .font(Font.headline.bold())
                                    
                                    Text(project.attributes.releaseDate ?? "Unknown releasedate")
                                        .font(Font.body.italic())
                                        .foregroundColor(Color(uiColor: UIColor.label))
                                }
                            }
                        }
                    }
                }
                
            }.padding(20)
        }.navigationTitle(viewModel.project.attributes.title)
            .onAppear{
                shouldStopReload = false
                viewModel.setIsSavedIcon(for: viewModel.project)
            }
            .navigationBarItems(trailing: Button(action: {
                viewModel.toggleSaveProject(viewModel.project)
                }, label: {
                    Image(systemName: viewModel.bookmarkString)
                }
              )
            )
    }
}
