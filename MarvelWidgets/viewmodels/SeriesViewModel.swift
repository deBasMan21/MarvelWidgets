//
//  SeriesViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

extension SeriesView {
    class SeriesViewModel: ObservableObject {
        @Published var series: [Serie] = []
        @Published var orderType: OrderType = .releaseDate
        
        func fetchSeries() async {
            _ = await MainActor.run {
                Task {
                    series = await SeriesService.getSeriesChronologically()
                    orderMovies(by: orderType)
                }
            }
        }
        
        func orderMovies(by orderType: OrderType) {
            self.orderType = orderType
            switch orderType {
            case .nameASC:
                series = series.sorted(by: { $0.title < $1.title})
            case .nameDESC:
                series = series.sorted(by: { $0.title > $1.title})
            case .releaseDate:
                series = series.sorted(by: { $0.releaseDate ?? "" > $1.releaseDate ?? ""})
            case .lastAired:
                series = series.sorted(by: { $0.lastAiredDate ?? "" > $1.lastAiredDate ?? ""})
            }
        }
        
        func refresh() async {
            await fetchSeries()
            orderMovies(by: orderType)
        }
    }
    
    enum OrderType: String, CaseIterable {
        case nameASC = "Naam A-Z"
        case nameDESC = "Naam Z-A"
        case releaseDate = "Release datum"
        case lastAired = "Laatste episode datum"
    }
}
