//
//  SeasonView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import ScrollViewIfNeeded
import Kingfisher

struct SeasonView: View {
    @State var seasons: [Season]
    @State var seriesTitle: String
    
    var body: some View {
        VStack {
            ForEach(seasons) { season in
                if let project = season.seasonProject?.data {
                    NavigationLink(destination: ProjectDetailView(viewModel: ProjectDetailViewModel(project: project), inSheet: false)) {
                        HStack {
                            KFImage(URL(string: season.imageUrl ?? ""))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                                .padding(.trailing)
                            
                            VStack(alignment: .leading) {
                                Text(project.attributes.title)
                                    .bold()
                                    .lineLimit(1)
                                
                                Text(project.attributes.getReleaseDateString())
                                    .foregroundColor(Color.foregroundColor)
                                
                                Text("Season \(season.seasonNumber)")
                                    .foregroundColor(Color.foregroundColor)
                                
                                Text("\(season.numberOfEpisodes ?? 0) episodes")
                                    .foregroundColor(Color.foregroundColor)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                
            }
        }
    }
}

struct SeasonEpisodeListView: View {
    @State var episodes: [Episode]
    @State var source: ProjectSource
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(episodes) { episode in
                    VStack {
                        NavigationLink(
                            destination: ProjectDetailView(
                                viewModel: ProjectDetailViewModel(
                                    project: episode.toProjectWrapper(source: source)
                                ),
                                inSheet: true,
                                isEpisode: true
                            )
                        ) {
                            HStack {
                                KFImage(episode.getUrl(large: false))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                
                                VStack {
                                    HStack {
                                        Text("\(episode.title) (Episode \(episode.episodeNumber))")
                                            .bold()
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                    }
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            if let duration = episode.duration {
                                                Text("\(duration) minutes")
                                                    .textStyle(RedChipText())
                                            }
                                            
                                            if let dateString = episode.episodeReleaseDate?.toDate()?.toFormattedString() {
                                                Text(dateString)
                                                    .textStyle(RedChipText())
                                            }
                                        }
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .foregroundColor(Color.accentColor)
                            }.foregroundColor(Color.foregroundColor)
                        }
                    }.padding()
                        .background(Color.filterGray)
                        .cornerRadius(10)
                }
            }.padding()
        }
    }
}

struct SeasonEpisodeView: View {
    @State var episodes: [Episode]
    @State var source: ProjectSource
    @State var showEpisodes: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                showEpisodes = true
            }, label: {
                HStack {
                    Spacer()
                    
                    Text("Episodes (\(episodes.count))")
                    
                    Spacer()
                }.padding()
                    .overlay(
                        HStack {
                            Spacer()
                            
                            Image(systemName: "square.stack.fill")
                        }.padding()
                    )
                    .background(
                        LinearGradient(
                            stops: [
                                .init(color: Color.accentColor, location: 0.0),
                                .init(color: Color.accentColor.withAlphaComponent(0.5), location: 1.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    ).foregroundColor(.white)
                    .bold()
                    .cornerRadius(10)
            }).autosizingSheet(showSheet: $showEpisodes) {
                NavigationView {
                    SeasonEpisodeListView(episodes: episodes, source: source)
                }
            }
        }
    }
}
