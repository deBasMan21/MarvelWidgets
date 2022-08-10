//
//  ContentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI

struct ContentView: View {
    @State var movies: [Movie] = []
    @State var series: [Serie] = []
    
    var body: some View {
        TabView{
            MoviesView()
                .tabItem{
                    Label("Movies", systemImage: "film.circle.fill")
                    Text("movies")
                }
            
            SeriesView()
                .tabItem{
                    Label("Series", systemImage: "tv.circle.fill")
                    Text("series")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
