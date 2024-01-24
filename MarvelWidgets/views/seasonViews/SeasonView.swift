//
//  SeasonView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation
import SwiftUI
import ScrollViewIfNeeded
import Kingfisher

struct SeasonView: View {
    @State var seasons: [Season]
    @State var seriesTitle: String
    
    var body: some View {
        VStack {
            ForEach(seasons) { season in
                if let project = season.seasonProject?.data {
                    NavigationLink(destination: ProjectDetailView(viewModel: ProjectDetailViewModel(project: project), inSheet: false)) {
                        VerticalListItemView(
                            imageUrl: season.imageUrl ?? "",
                            title: project.attributes.title,
                            multilineDescription: "\(project.attributes.getReleaseDateString())\nSeason \(season.seasonNumber)\n\(season.numberOfEpisodes ?? 0) episodes"
                        )
                    }
                }
                
            }
        }
    }
}
