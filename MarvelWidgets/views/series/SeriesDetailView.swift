//
//  SeriesDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI
import Kingfisher

struct SeriesDetailView: View {
    @State var serie: Serie
    
    var body: some View {
        VStack {
            ScrollView {
                KFImage(URL(string: serie.coverURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text(serie.title)
                
                Text(serie.releaseDate ?? "Unkown releasedate")
                
                Text(serie.directedBy ?? "Unkown director")
                
                Text("\(serie.numberEpisodes) afleveringen")
                
                Text("\(serie.numberSeasons) seizoenen")
                
                Text("Phase \(serie.phase)")
                
                Text(serie.saga?.rawValue ?? "Unkown saga")
                
                Text(serie.overview ?? "No overview")
            }
        }.navigationTitle(serie.title)
    }
}
