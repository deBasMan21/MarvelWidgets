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
    @Binding var shouldStopReload: Bool
    
    var body: some View {
        ScrollView {
            VStack{
                HStack(alignment: .top) {
                    NavigationLink(destination: FullscreenImageView(url: viewModel.project.attributes.posters?.first?.posterURL ?? "")) {
                        KFImage(URL(string: viewModel.project.attributes.posters?.first?.posterURL ?? "")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, alignment: .center)
                            .cornerRadius(12)
                            .padding(.trailing, 20)
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
                            Text("**Phase \(viewModel.project.attributes.phase.rawValue)**")
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
                                Text("**\(postCreditScenes) post credit scene(s)**")
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
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                ForEach(posters, id: \.posterURL) { poster in
                                    NavigationLink(destination: FullscreenImageView(url: poster.posterURL)) {
                                        ImageSizedView(url: poster.posterURL)
                                    }
                                }
                            }
                        }
                    }.padding()
                }
                
                if let actors = viewModel.project.attributes.actors, actors.data.count > 0 {
                    VStack {
                        Text("Actors")
                            .font(.largeTitle)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(actors.data, id: \.uuid) { actorItem in
                                    VStack {
                                        if let url = actorItem.attributes.imageURL {
                                            ImageSizedView(url: url)
                                        }
                                        
                                        Text("\(actorItem.attributes.firstName) \(actorItem.attributes.lastName)")
                                            .bold()
                                            .foregroundColor(.accentColor)
                                        
                                        if let birthDay = actorItem.attributes.dateOfBirth {
                                            Text("\(birthDay)")
                                        }
                                    }
                                }
                            }
                        }
                    }.padding()
                }
                
                if let directors = viewModel.project.attributes.directors, directors.data.count > 0 {
                    VStack {
                        Text("Directors")
                            .font(.largeTitle)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(directors.data, id: \.uuid) { directorItem in
                                    VStack {
                                        if let url = directorItem.attributes.imageURL {
                                            ImageSizedView(url: url)
                                        }
                                        
                                        Text("\(directorItem.attributes.firstName) \(directorItem.attributes.lastName)")
                                            .bold()
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                        }
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
                    }.padding()
                }
            }
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

struct SeasonView: View {
    @State var seasons: [Season]
    @State var seriesTitle: String
    @State var isActive: Bool = false
    
    var body: some View {
        VStack {
            Text("Seasons")
                .font(.largeTitle)
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(seasons, id: \.uuid) { season in
                        NavigationLink(destination: SeasonDetailView(season: season, seriesTitle: seriesTitle)) {
                            VStack {
                                Text("Season \(season.seasonNumber)")
                                    .bold()
                                    .foregroundColor(.accentColor)
                                
                                Text("\(season.numberOfEpisodes ?? 0) episodes")
                            }.padding()
                                .frame(width: 220)
                                .background(Color("ListItemBackground"))
                                .cornerRadius(5)
                                .foregroundColor(Color("ForegroundColor"))
                        }
                        
                    }
                }
            }
        }
    }
}

struct SeasonDetailView: View {
    @State var season: Season
    @State var seriesTitle: String
    
    @StateObject var selectedIndex: Page = .first()
    @StateObject var selectedImage: Page = .first()
    
    @State var isActive = false
    
    var body: some View {
        ScrollView {
            if let episodes = season.episodes {
                VStack {
                    Text("Episode info")
                        .font(.largeTitle)
                    
                    Text("(\(season.numberOfEpisodes ?? 0) episodes)")
                    
                    Pager(
                        page: selectedIndex,
                        data: episodes,
                        content: { episode in
                            VStack {
                                Text("\(episode.title) (Episode \(episode.episodeNumber))")
                                    .bold()
                                    .multilineTextAlignment(.center)

                                Text(episode.episodeReleaseDate)

                                Text("Overview")
                                    .bold()
                                    .padding(.top)

                                Text(episode.episodeDescription)

                                Text("\(episode.postCreditScenes) post credit scenes")
                                    .bold()
                                    .padding(.top)

                                Text("Duration")
                                    .bold()
                                    .padding(.top)

                                Text("\(episode.duration) minutes")

                                Spacer()
                            }.padding()
                                .frame(width: 300)
                                .background(Color("ListItemBackground"))
                                .cornerRadius(12)
                                .foregroundColor(Color("ForegroundColor"))
                        }
                    )
                        .preferredItemSize(CGSize(width: 280, height: 400))
                        .multiplePagination()
                        .itemSpacing(10)
                        .interactive(rotation: true)
                        .interactive(scale: 0.7)
                        .frame(height: 400)
                        
                }.padding()
            }
            
            if let trailers = season.seasonTrailers {
                TrailersView(trailers: trailers)
            }
            
            if let posters = season.posters {
                VStack {
                    Text("Posters")
                        .font(.largeTitle)
                    
                    Pager(
                        page: selectedImage,
                        data: posters,
                        content: { poster in
                            VStack {
                                NavigationLink(destination: FullscreenImageView(url: poster.posterURL), isActive: $isActive) {
                                    EmptyView()
                                }
                                
                                ImageSizedView(url: poster.posterURL)
                                    .onTapGesture {
                                        isActive = true
                                    }
                            }
                        }
                    )
                        .sensitivity(.high)
                        .preferredItemSize(CGSize(width: 150, height: 250))
                        .multiplePagination()
                        .itemSpacing(10)
                        .interactive(rotation: true)
                        .interactive(scale: 0.7)
                        .frame(height: 250)
                }.padding()
            }
        }.navigationTitle("\(seriesTitle) Season \(season.seasonNumber)")
    }
}

struct FullscreenImageView: View {
    @State var url: String
    
    var body: some View {
        if #available(iOS 16.0, *) {
            VStack {
                KFImage(URL(string: url)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }.navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: ShareLink(item: URL(string: url)!))
        } else {
            VStack {
                KFImage(URL(string: url)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }.navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TrailersView: View {
    @State var trailers: [Trailer]
    
    @State var trailersIndex: Page = .first()
    
    var body: some View {
        VStack {
            Text("Trailers")
                .font(.largeTitle)
            
            Pager(
                page: trailersIndex,
                data: trailers,
                content: { trailer in
                    VStack {
                        Text(trailer.trailerName)
                            .bold()
                            .foregroundColor(.accentColor)
                        
                        VideoView(videoURL: trailer.youtubeLink)
                            .frame(width: 300, height: 170)
                            .cornerRadius(12)
                    }
                }
            )
                .preferredItemSize(CGSize(width: 280, height: 200))
                .multiplePagination()
                .itemSpacing(10)
                .interactive(rotation: true)
                .interactive(scale: 0.7)
                .frame(height: 200)
        }.padding()
    }
}

struct ImageSizedView: View {
    @State var url: String
    
    @State var width: CGFloat = 150
    @State var height: CGFloat = 250
    
    var body: some View {
        KFImage(URL(string: url))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height, alignment: .center)
            .cornerRadius(12)
    }
}
