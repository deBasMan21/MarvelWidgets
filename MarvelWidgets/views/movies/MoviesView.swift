//
//  MoviesView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI

struct MoviesView: View {
    @State var movies : [Movie] = []
    
    var body: some View {
        NavigationView {
            List(movies) { item in
                Text(item.title)
            }.navigationTitle("Marvel movies")
        }.onAppear{
            Task{
                movies = await MovieService.getMoviesChronologically()
            }
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
