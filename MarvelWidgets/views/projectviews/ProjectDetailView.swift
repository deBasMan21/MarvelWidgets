//
//  ProjectDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import SwiftUI
import Kingfisher
import SwiftUIPager

struct ProjectDetailView: View {
    @StateObject var viewModel: ProjectDetailViewModel
    @Binding var showLoader: Bool
    
    var body: some View {
        ScrollView {
            VStack{
                HStack(alignment: .top) {
                    NavigationLink(destination: FullscreenImageView(url: viewModel.project.attributes.posters?.first?.posterURL ?? "")) {
                        if let posterURL = viewModel.project.attributes.posters?.first?.posterURL {
                            KFImage(URL(string: posterURL)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, alignment: .center)
                                .cornerRadius(12)
                                .padding(.trailing, 20)
                                .onAppear {
                                    withAnimation {
                                        showLoader = false
                                    }
                                }
                        }
                    }
                    
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
                            Text("**\(viewModel.project.attributes.phase.rawValue)**")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("**\(viewModel.project.attributes.saga.rawValue)**")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("**Type project**")
                            Text(viewModel.project.attributes.type.rawValue)
                        }
                        
                        if let boxOffice = viewModel.project.attributes.boxOffice {
                            VStack(alignment: .leading) {
                                Text("**Box office**")
                                Text(boxOffice.toMoney())
                            }
                        }
                        
                        if let duration = viewModel.project.attributes.duration {
                            VStack(alignment: .leading) {
                                Text("**Duration**")
                                Text("\(duration) minutes")
                            }
                        }
                        
                        if let postCreditScenes = viewModel.project.attributes.postCreditScenes {
                            VStack(alignment: .leading) {
                                Text("**\(postCreditScenes) post credit scene\(postCreditScenes != 1 ? "s" : "")**")
                            }
                        }
                    }
                    
                    Spacer()
                }.padding(20)
                
                if let overview = viewModel.project.attributes.overview {
                    VStack {
                        Text("Overview")
                            .font(Font.largeTitle)
                            .padding()
                        
                        Text(overview)
                            .multilineTextAlignment(.center)
                    }.padding()
                }
                
                if let seasons = viewModel.project.attributes.seasons, seasons.count > 0 {
                    SeasonView(seasons: seasons, seriesTitle: viewModel.project.attributes.title)
                        .padding()
                }
                
                if let trailers = viewModel.project.attributes.trailers, trailers.count > 0 {
                    TrailersView(trailers: trailers)
                }
                
                if let posters = viewModel.project.attributes.posters {
                    VStack {
                        Text("Posters")
                            .font(.largeTitle)
                        
                        PosterListView(posters: posters)
                    }.padding()
                }
                
                if let actors = viewModel.project.attributes.actors, actors.data.count > 0 {
                    VStack {
                        Text("Actors")
                            .font(.largeTitle)
                        
                        ActorListView(
                            actors: actors.data,
                            showLoader: $showLoader
                        )
                    }.padding()
                }
                
                if let directors = viewModel.project.attributes.directors, directors.data.count > 0 {
                    VStack {
                        Text("Directors")
                            .font(.largeTitle)
                        
                        DirectorListView(
                            directors: directors.data,
                            showLoader: $showLoader
                        )
                    }.padding()
                }
                
                if let relatedProjects = viewModel.project.attributes.relatedProjects, relatedProjects.data.count > 0 {
                    VStack {
                        Text("Related projects")
                            .font(Font.largeTitle)
                            .padding()
                        
                        VStack(spacing: 15){
                            ForEach(relatedProjects.data, id: \.uuid) { project in
                                NavigationLink {
                                    ProjectDetailView(
                                        viewModel: ProjectDetailViewModel(
                                            project: project
                                        ),
                                        showLoader: $showLoader
                                    )
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
                    }.padding()
                }
            }
        }.navigationTitle(viewModel.project.attributes.title)
            .navigationBarItems(trailing: Button(action: {
                if let dpUrl = viewModel.project.attributes.disneyPlusUrl {
                    UIApplication.shared.open(URL(string: dpUrl)!)
                }
                
                }, label: {
                    VStack {
                        if viewModel.project.attributes.disneyPlusUrl != nil {
                            Image(systemName: "play.fill")
                        } else {
                            EmptyView()
                        }
                    }
                }
              )
            )
    }
}
