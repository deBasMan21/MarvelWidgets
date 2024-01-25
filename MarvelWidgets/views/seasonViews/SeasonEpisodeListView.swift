//
//  SeasonEpisodeListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 24/01/2024.
//

import Foundation
import SwiftUI
import Kingfisher

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
