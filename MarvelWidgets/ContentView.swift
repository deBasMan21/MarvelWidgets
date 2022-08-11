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
            ProjectListView(type: .all)
                .tabItem{
                    Label("All", systemImage: "list.dash")
                }
            
            ProjectListView(type: .movies)
                .tabItem{
                    Label("Movies", systemImage: "film")
                }
            
            ProjectListView(type: .series)
                .tabItem{
                    Label("Series", systemImage: "tv")
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
