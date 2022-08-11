//
//  ProjectDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import SwiftUI
import Kingfisher

struct ProjectDetailView: View {
    @State var movie: Project
    
    var body: some View {
        ScrollView {
            VStack{
                HStack {
                    KFImage(URL(string: movie.coverURL)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, alignment: .center)
                        .padding(.trailing, 20)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(movie.title)
                            .font(Font.headline.bold())
                        
                        if let director = movie.directedBy, !director.isEmpty {
                            Text(movie.directedBy!)
                        } else {
                            Text("No director confirmed")
                        }
                        
                        Text(movie.releaseDate ?? "No release date set")
                        
                        if let movie = movie as? Movie {
                            Text("\(movie.duration) minuten")
                            
                            Text("\(movie.postCreditScenes) post credit scenes")
                            
                            Text("€\(movie.boxOffice.toMoney()),- box office")
                        } else if let movie = movie as? Serie {
                            Text("\(movie.numberEpisodes) afleveringen")
                            
                            Text("\(movie.numberSeasons) seizoenen")
                        }
                        
                        Text("Phase \(movie.phase)")
                        
                        Text(movie.saga?.rawValue ?? "Unkown saga")
                    }
                }
                
                Text(movie.overview ?? "No overview")
                    .multilineTextAlignment(.center)
                
            }.padding(.horizontal, 20)
        }.navigationTitle(movie.title)
    }
}
