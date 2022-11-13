//
//  SeasonView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import SwiftUIPager

struct SeasonView: View {
    @State var seasons: [Season]
    @State var seriesTitle: String
    
    @State var selectedSeason: Page = .first()
    @State var activeSeasons: [Int: Bool] = [:]
    
    var body: some View {
        VStack {
            Text("Seasons")
                .font(.largeTitle)
            
            Pager(
                page: selectedSeason,
                data: seasons,
                content: { season in
                    VStack {
                        NavigationLink(destination: SeasonDetailView(season: season, seriesTitle: seriesTitle), isActive: binding(for: season.id)) {
                            EmptyView()
                        }
                        
                        VStack {
                            Text("Season \(season.seasonNumber)")
                                .bold()
                                .foregroundColor(.accentColor)
                            
                            if let numberOfEpisodes = season.numberOfEpisodes {
                                Text("\(numberOfEpisodes) episodes")
                            }
                            
                            if season.posters?.count ?? 0 <= 0 && season.seasonTrailers?.count ?? 0 <= 0 && season.episodes?.count ?? 0 <= 0 {
                                Text("*Details available soon*")
                            } else {
                                Text("*Click for details*")
                            }
                        }.padding()
                            .frame(width: 220)
                            .background(Color("ListItemBackground"))
                            .cornerRadius(5)
                            .foregroundColor(Color("ForegroundColor"))
                            .onTapGesture {
                                if season.posters?.count ?? 0 > 0 || season.seasonTrailers?.count ?? 0 > 0 || season.episodes?.count ?? 0 > 0 {
                                    activeSeasons[season.id] = true
                                }
                            }
                    }
                }
            )
                .preferredItemSize(CGSize(width: 220, height: 100))
                .multiplePagination()
                .interactive(scale: 0.9)
                .itemSpacing(10)
                .frame(height: 100)
        }
    }
    
    private func binding(for key: Int) -> Binding<Bool> {
        return .init(
            get: { self.activeSeasons[key, default: false] },
            set: { self.activeSeasons[key] = $0 })
    }
}
