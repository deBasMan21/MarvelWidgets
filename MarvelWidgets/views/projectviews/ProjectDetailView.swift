//
//  ProjectDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import SwiftUI
import Kingfisher
import SwiftUIPager
import SwiftUINavigationHeader

struct ProjectDetailView: View {
    @StateObject var viewModel: ProjectDetailViewModel
    @Binding var showLoader: Bool
    
    var body: some View {
        NavigationHeaderContainer(bottomFadeout: true) {
            KFImage(URL(string: viewModel.project.attributes.posters?.first?.posterURL ?? "")!)
                .resizable()
                .scaledToFill()
        } content: {
                VStack {
                    Text(viewModel.project.attributes.title)
                        .font(Font.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    LazyVGrid(columns: viewModel.columns)  {
                        VStack(alignment: .leading, spacing: 10) {
                            if let director =
                                viewModel.project
                                .attributes
                                .directors?
                                .data
                                .compactMap({ "\($0.attributes.firstName) \($0.attributes.lastName)"})
                                .joined(separator: ", "),
                               !director.isEmpty {
                                VStack(alignment: .leading) {
                                    Text("**Director**")
                                    Text(director)
                                }
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
                            
                            if let saga = viewModel.project.attributes.saga {
                                VStack(alignment: .leading) {
                                    Text("**\(saga.rawValue)**")
                                }
                            }
                            
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            VStack(alignment: .leading) {
                                Text("**Release date**")
                                Text(viewModel.project.attributes.releaseDate ?? "No release date set")
                            }
                            
                            if let duration = viewModel.project.attributes.duration {
                                VStack(alignment: .leading) {
                                    Text("**Duration**")
                                    Text("\(duration) minutes")
                                }
                            }
                            
                            if let postCreditScenes = viewModel.project.attributes.postCreditScenes {
                                VStack(alignment: .leading) {
                                    Text("**\(postCreditScenes) post credit scene\(postCreditScenes != 1 ? "s" : "")**\n")
                                }
                            }
                            
                            if let phase = viewModel.project.attributes.phase {
                                VStack(alignment: .leading) {
                                    Text("**\(phase.rawValue)**")
                                }
                            }
                            
                            Spacer()
                        }
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
                    
                    if let posters = viewModel.project.attributes.posters {
                        VStack {
                            Text("Posters")
                                .font(.largeTitle)
                            
                            PosterListView(posters: posters)
                        }.padding()
                    }
                    
                    if let trailers = viewModel.project.attributes.trailers, trailers.count > 0 {
                        TrailersView(trailers: trailers)
                    }
                    
                    if let seasons = viewModel.project.attributes.seasons, seasons.count > 0 {
                        SeasonView(seasons: seasons, seriesTitle: viewModel.project.attributes.title)
                            .padding()
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
                    
                    if viewModel.showBottomLoader {
                        ProgressView()
                            .padding()
                    }
                }.offset(x: 0, y: -50)
        }.baseTintColor(Color("AccentColor"))
            .headerHeight({ _ in 300 })
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
            }))
        }
}
