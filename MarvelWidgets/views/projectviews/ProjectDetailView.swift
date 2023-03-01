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
        NavigationHeaderContainer(bottomFadeout: true, headerAlignment: .center, header: {
            NavigationLink(destination: FullscreenImageView(url: viewModel.posterURL)) {
                KFImage(URL(string: viewModel.posterURL)!)
                    .resizable()
                    .scaledToFill()
                    .gesture(DragGesture().onEnded { value in
                        viewModel.swipeImage(direction: viewModel.detectDirection(value: value))
                    })
            }
        }, content: {
                VStack {
                    Text("Poster \(viewModel.posterIndex + 1) of \(viewModel.project.attributes.posters?.count ?? 0)")
                        .font(Font.footnote)
                        .italic()
                    
                    Text(viewModel.project.attributes.title)
                        .font(Font.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    LazyVGrid(columns: viewModel.columns, alignment: .leading)  {
                        HStack {
                            Image(systemName: viewModel.project.attributes.type.imageString())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading) {
                                Text("Type project")
                                    .bold()
                                    .foregroundColor(Color.accentColor)
                                
                                Text(viewModel.project.attributes.type.rawValue)
                            }
                        }
                    
                        HStack {
                            Image(systemName: "calendar.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading) {
                                Text("Release date")
                                    .bold()
                                    .foregroundColor(Color.accentColor)
                                
                                Text(viewModel.project.attributes.releaseDate?.toDate()?.toFormattedString() ?? "No release date set")
                            }
                        }.onTapGesture {
                            viewModel.createEventinTheCalendar()
                        }
                        
                        if let duration = viewModel.project.attributes.duration {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading)  {
                                    Text("Duration")
                                        .bold()
                                        .foregroundColor(Color.accentColor)
                                    
                                    Text("\(duration) minutes")
                                }
                            }
                        }
                        
                        if let directors = viewModel.project.attributes.directors, directors.data.count > 0 {
                            ForEach(directors.data) { director in
                                NavigationLink(destination: DirectorDetailView(director: director, showLoader: $showLoader)) {
                                    HStack {
                                        KFImage(URL(string: director.attributes.imageURL ?? "")!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                        
                                        VStack(alignment: .leading)  {
                                            Text("Director")
                                                .bold()
                                            
                                            Text("\(director.attributes.firstName) \(director.attributes.lastName)")
                                                .lineLimit(1)
                                                .foregroundColor(Color.foregroundColor)
                                        }
                                    }
                                }
                            }
                        }
                    }.padding(20)
                    
                    if let overview = viewModel.project.attributes.overview {
                        VStack {
                            Text(overview)
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                            
                            VStack(spacing: 10) {
                                if let saga = viewModel.project.attributes.saga {
                                    VStack(alignment: .leading) {
                                        Text("**\(saga.rawValue)**")
                                    }
                                }
                                
                                if let phase = viewModel.project.attributes.phase {
                                    VStack(alignment: .leading) {
                                        Text("**\(phase.rawValue)**")
                                    }
                                }
                                
                                if let postCreditScenes = viewModel.project.attributes.postCreditScenes {
                                    VStack(alignment: .leading) {
                                        Text("**\(postCreditScenes) post credit scene\(postCreditScenes != 1 ? "s" : "")**")
                                    }
                                }
                                
                                if let boxOffice = viewModel.project.attributes.boxOffice {
                                    VStack(alignment: .leading) {
                                        Text("**\(boxOffice.toMoney())**")
                                    }
                                }
                            }
                        }.padding()
                    }
                    
                    if let seasons = viewModel.project.attributes.seasons, seasons.count > 0 {
                        SeasonView(seasons: seasons, seriesTitle: viewModel.project.attributes.title)
                            .padding()
                    }
                    
                    if let actors = viewModel.project.attributes.actors, actors.data.count > 0 {
                        ActorListView(
                            actors: actors.data,
                            showLoader: $showLoader
                        ).padding()
                    }
                    
                    if let trailers = viewModel.project.attributes.trailers, trailers.count > 0 {
                        TrailersView(trailers: trailers)
                    }
                    
                    if let relatedProjects = viewModel.project.attributes.relatedProjects, relatedProjects.data.count > 0 {
                        VStack {
                            Text("Related projects")
                                .font(Font.largeTitle)
                                .padding()
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15){
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
                                                ImageSizedView(url: project.attributes.posters?.first?.posterURL ?? "")
                                                
                                                Text(project.attributes.title)
                                                    .font(Font.headline.bold())
                                                
                                                Text(project.attributes.releaseDate?.toDate()?.toFormattedString() ?? "Unknown releasedate")
                                                    .font(Font.body.italic())
                                                    .foregroundColor(Color(uiColor: UIColor.label))
                                            }.frame(width: 150)
                                        }
                                    }
                                }
                            }
                        }.padding(.horizontal)
                    }
                    
                    if viewModel.showBottomLoader {
                        ProgressView()
                            .padding()
                    }
                }.offset(x: 0, y: -50)
        }, toolbar: { state in
            HeaderToolbarItem(barState: state, content: {
                VStack {
                    if viewModel.project.attributes.disneyPlusUrl != nil {
                        Image(systemName: "play.fill")
                    } else {
                        EmptyView()
                    }
                }.onTapGesture {
                    if let dpUrl = viewModel.project.attributes.disneyPlusUrl {
                        UIApplication.shared.open(URL(string: dpUrl)!)
                    }
                }
            })
        }).baseTintColor(Color("AccentColor"))
            .headerHeight({ _ in 500 })
            .alert(isPresented: $viewModel.showAlert, content: {
                Alert(title: Text("Succes!"), message: Text("Added \(viewModel.project.attributes.title) to your calendar on \(viewModel.project.attributes.releaseDate?.toDate()?.toFormattedString() ?? "")"))
            })
    }
}
