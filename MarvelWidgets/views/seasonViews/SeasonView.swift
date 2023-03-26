//
//  SeasonView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI

struct SeasonView: View {
    @State var seasons: [Season]
    @State var seriesTitle: String
    
    @State var activeSeason: Int = 0
    
    var body: some View {
        VStack {
            Text("Seasons")
                .font(.largeTitle)
            
            VStack(spacing: 20) {
                ForEach(seasons) { season in
                    VStack {
                        HStack {
                            Image(systemName: "arrowtriangle.right")
                                .rotationEffect(.degrees(activeSeason == season.id ? 90 : 0))
                            
                            VStack {
                                Text("Season \(season.seasonNumber)")
                                    .bold()
                                    .foregroundColor(.accentColor)
                                
                                let episodesString = season.numberOfEpisodes != nil ? "\(season.numberOfEpisodes ?? 0) episodes" : "Coming soon"
                                Text(episodesString)
                            }
                        }
                        
                        if activeSeason == season.id {
                            if let episodes = season.episodes, episodes.count > 0 {
                                SeasonEpisodeListView(episodes: episodes)
                            } else {
                                Text("More season information coming soon")
                                    .padding()
                            }
                        }
                    }.onTapGesture {
                        let activeSeasonIsTheSame = activeSeason == season.id
                        
                        withAnimation {
                            activeSeason = activeSeasonIsTheSame ? 0 : season.id
                        }
                    }
                }
            }
        }
    }
}


struct SeasonEpisodeListView: View {
    @State var episodes: [Episode]
    
    var body: some View {
        VStack {
            ForEach(episodes) { episode in
                VStack {
                    Text("\(episode.title) (Episode \(episode.episodeNumber))")
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Text("\(episode.duration) minutes")
                                .textStyle(RedChipText())
                            
                            Text(episode.episodeReleaseDate.toDate()?.toFormattedString() ?? "")
                                .textStyle(RedChipText())

                            Text("\(episode.postCreditScenes) post credit scenes")
                                .textStyle(RedChipText())
                        }
                    }
                    
                    Text(episode.episodeDescription)
                        .multilineTextAlignment(.center)
                    
                }.padding()
                    .background(Color.accentGray)
                    .cornerRadius(10)
                    .padding()
            }
        }
    }
}
