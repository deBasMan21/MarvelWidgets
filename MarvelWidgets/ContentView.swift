//
//  ContentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI

struct ContentView: View {
    @State var movies: [Movie] = []
    
    var body: some View {
        VStack{
            List(movies) { item in
                Text(item.title)
            }
        }.onAppear{
                Task{
                    do {
                        movies = await MovieService.getMoviesChronologically()
                    } catch let error {
                        print(error)
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
