//
//  SeriesView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI

struct SeriesView: View {
    @StateObject var viewModel = SeriesViewModel()
    
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
                
                List(viewModel.series) { item in
                    NavigationLink{
                        SeriesDetailView(serie: item)
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
            }.navigationTitle("Marvel series")
        }.onAppear{
            Task{
                await viewModel.fetchSeries()
            }
        }
    }
}
