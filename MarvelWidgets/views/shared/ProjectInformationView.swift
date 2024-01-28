//
//  ProjectInformationView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/03/2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct ProjectInformationView: View {
    @Binding var project: ProjectWrapper
    @Binding var posterIndex: Int
    @Binding var showCalendarAppointment: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Poster \(posterIndex + 1) of \(project.attributes.posters?.count ?? 0)")
                    .font(Font.footnote)
                    .italic()
                
                Text(project.attributes.title)
                    .font(Font.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            
            if let categoriesString = project.attributes.categories {
                HScrollView(showsIndicators: false) {
                    HStack {
                        ForEach(categoriesString.split(separator: ", ").compactMap { String($0) }, id: \.hashValue) { category in
                            Text(category)
                                .textStyle(RedChipText())
                        }
                    }
                }.padding(.bottom, 20)
            }
            
            LazyVGrid(columns: columns, alignment: .leading)  {
                GridItemView(
                    imageName: project.attributes.type.imageString(),
                    title: "Type project",
                    value: project.attributes.type.rawValue
                )
            
                GridItemView(
                    imageName: "calendar.circle.fill",
                    title: "Release date",
                    value: project.attributes.getReleaseDateString()
                ).onTapGesture {
                    showCalendarAppointment = true
                }
                
                GridItemView(
                    imageName: "s.circle.fill",
                    title: "Source",
                    value: project.attributes.source.toString()
                )
                
                if let duration = project.attributes.duration {
                    GridItemView(
                        imageName: "clock.fill",
                        title: "Duration",
                        value: "\(duration) minutes"
                    )
                }
                
                if let directors = project.attributes.directors, directors.data.count > 0 {
                    ForEach(directors.data) { director in
                        NavigationLink(destination: PersonDetailView(person: director.person)) {
                            GridItemView(
                                imageName: director.attributes.imageURL ?? "",
                                title: "Director",
                                value: "\(director.attributes.firstName) \(director.attributes.lastName)"
                            ).foregroundStyle(.white)
                        }
                    }
                }
                
                if project.attributes.rankingCurrentRank != nil, project.attributes.rankingDifference != nil, let rankingChangeDirection = project.attributes.rankingChangeDirection {
                    GridItemView(
                        imageName: rankingChangeDirection.toImage(),
                        title: "Ranking",
                        value: project.attributes.getRankingChangeString()
                    )
                }
            }
        }
    }
}

struct GridItemView: View {
    @State var imageName: String
    @State var title: String
    @State var value: String
    
    var body: some View {
        HStack {
            if imageName.hasPrefix("https://") {
                KFImage(URL(string: imageName))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                    .foregroundColor(Color.accentColor)
                
                Text(value)
                    .lineLimit(1)
            }
        }
    }
}
