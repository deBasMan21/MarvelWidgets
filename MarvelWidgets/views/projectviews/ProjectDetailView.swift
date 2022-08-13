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
    
    var body: some View {
        ScrollView {
            VStack{
                HStack(alignment: .top) {
                    KFImage(URL(string: viewModel.project.coverURL)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, alignment: .center)
                        .cornerRadius(12)
                        .padding(.trailing, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading) {
                            Text("**Director**")
                            if let director = viewModel.project.directedBy, !director.isEmpty {
                                Text(viewModel.project.directedBy!)
                            } else {
                                Text("No director confirmed")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("**Release date**")
                            Text(viewModel.project.releaseDate ?? "No release date set")
                        }
                        
                        if let project = viewModel.project as? Movie {
                            VStack(alignment: .leading) {
                                Text("**Duration**")
                                Text("\(project.duration) minutes")
                            }
                            
                            VStack(alignment: .leading) {
                                Text("**Post credit scenes**")
                                Text("\(project.postCreditScenes)")
                            }
                            
                            VStack(alignment: .leading) {
                                Text("**Box office**")
                                Text("€\(project.boxOffice.toMoney()),- ")
                            }
                        } else if let project = viewModel.project as? Serie {
                            VStack(alignment: .leading) {
                                Text("**Episodes**")
                                Text("\(project.numberEpisodes)")
                            }
                            
                            VStack(alignment: .leading) {
                                Text("**Seasons**")
                                Text("\(project.numberSeasons) seasons")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("**Phase \(viewModel.project.phase)**")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("**\(viewModel.project.saga?.rawValue ?? "Unkown saga")**")
                        }
                    }
                    
                    Spacer()
                }
                
                if let overview = viewModel.project.overview {
                    Text("Overview")
                        .font(Font.largeTitle)
                        .padding()
                    
                    Text(overview)
                        .multilineTextAlignment(.center)
                }
                
                if let url = viewModel.project.trailerURL {
                    Text("Trailer")
                        .font(Font.largeTitle)
                        .padding()
                    
                    VideoView(videoURL: url)
                        .frame(height: 200)
                        .cornerRadius(12)
                }
                
                if let relatedProjects = viewModel.movie?.relatedMovies {
                    Text("Related projects")
                        .font(Font.largeTitle)
                        .padding()
                    
                    VStack(spacing: 15){
                        ForEach(relatedProjects, id: \.id) { movie in
                            NavigationLink {
                                ProjectDetailView(viewModel: ProjectDetailViewModel(project: movie))
                            } label: {
                                VStack{
                                    Text(movie.title)
                                        .font(Font.headline.bold())
                                    
                                    Text(movie.releaseDate ?? "Unknown releasedate")
                                        .font(Font.body.italic())
                                        .foregroundColor(Color(uiColor: UIColor.label))
                                }
                            }
                        }
                    }
                }
                
            }.padding(20)
        }.navigationTitle(viewModel.project.title)
            .onAppear{
                if viewModel.project is Movie {
                    Task {
                        await viewModel.getMovieDetails()
                    }
                }
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
