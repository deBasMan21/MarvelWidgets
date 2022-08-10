//
//  MoviesDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI
import Kingfisher

struct MoviesDetailView: View {
    @State var movie: Movie
    
    var body: some View {
        ScrollView {
            VStack {
                KFImage(URL(string: movie.coverURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text(movie.title)
                
                Text(movie.releaseDate!)
                
                Text(movie.directedBy)
                
                Text("\(movie.duration) minuten")
                
                Text("\(movie.postCreditScenes) post credit scenes")
                
                Text("€\(movie.boxOffice.toMoney()),- box office")
                
                Text("Phase \(movie.phase)")
                
                Text(movie.saga.rawValue)
                
                Text(movie.overview ?? "No overview")
            }.padding(.horizontal, 20)
        }.navigationTitle(movie.title)
    }
}
