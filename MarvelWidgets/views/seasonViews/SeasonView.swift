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
