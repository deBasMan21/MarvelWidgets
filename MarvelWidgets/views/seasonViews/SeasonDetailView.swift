//
//  SeasonDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import SwiftUIPager

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
                    
                    PosterListView(posters: posters)
                    
                }.padding()
            }
        }.navigationTitle("\(seriesTitle) Season \(season.seasonNumber)")
    }
}
