//
//  SeriesView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI

struct SeriesView: View {
    @State var series: [Serie] = []
    
    var body: some View {
        NavigationView {
            List(series) { item in
                NavigationLink{
                    SeriesDetailView(serie: item)
                } label: {
                    Text(item.title)
                }
            }.navigationTitle("Marvel series")
        }.onAppear{
            Task{
                series = await SeriesService.getSeriesChronologically()
            }
        }
    }
}

struct SeriesView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesView()
    }
}
