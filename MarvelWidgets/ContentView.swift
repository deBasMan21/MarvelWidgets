//
//  ContentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State var movies: [Movie] = []
    @State var series: [Serie] = []
    
    var body: some View {
        TabView{
            MoviesView()
                .tabItem{
                    Label("Movies", systemImage: "film.circle.fill")
                }
            
            SeriesView()
                .tabItem{
                    Label("Series", systemImage: "tv.circle.fill")
                }
            
            WidgetSettingsView()
                .tabItem{
                    Label("Instellingen", systemImage: "gearshape")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
