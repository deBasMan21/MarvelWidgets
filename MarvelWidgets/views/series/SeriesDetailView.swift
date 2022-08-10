//
//  SeriesDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI

struct SeriesDetailView: View {
    @State var serie: Serie
    @State var image: Image = Image(uiImage: UIImage())
    
    var body: some View {
        VStack {
            ScrollView {
                image
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
            }.onAppear {
                downloadImage()
            }
        }.navigationTitle(serie.title)
    }
    
    func downloadImage() {
        image = ImageHelper.downloadImage(from: serie.coverURL)
    }
}
