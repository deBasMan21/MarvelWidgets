//
//  MoviesView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI

struct MoviesView: View {
    @StateObject var viewModel = MoviesViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                Menu(content: {
                    ForEach(OrderType.allCases, id: \.self){ item in
                        Button(item.rawValue, action: {
                            viewModel.orderMovies(by: item)
                        })
                    }
                }, label: {
                    Text("Sorteren op: \(String(describing: viewModel.orderType.rawValue))")
                    Image(systemName: "arrow.up.arrow.down")
                })
                
                List(viewModel.movies) { item in
                    NavigationLink{
                        MoviesDetailView(movie: item)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(Font.headline.bold())
                            
                            Text(item.releaseDate ?? "Onbekende releasedatum")
                                .font(Font.body.italic())
                        }
                    }
                }.refreshable {
                    Task {
                        await viewModel.refresh()
                    }
                }
            }.navigationTitle("Marvel movies")
        }.onAppear{
            Task{
                await viewModel.fetchMovies()
            }
        }
    }
}
