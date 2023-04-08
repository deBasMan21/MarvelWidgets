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
                HStack {
                    Image(systemName: project.attributes.type.imageString())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        Text("Type project")
                            .bold()
                            .foregroundColor(Color.accentColor)
                        
                        Text(project.attributes.type.rawValue)
                    }
                }
            
                HStack {
                    Image(systemName: "calendar.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        Text("Release date")
                            .bold()
                            .foregroundColor(Color.accentColor)
                        
                        Text(project.attributes.getReleaseDateString())
                    }
                }.onTapGesture {
                    showCalendarAppointment = true
                }
                
                if let duration = project.attributes.duration {
                    HStack {
                        Image(systemName: "clock.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading)  {
                            Text("Duration")
                                .bold()
                                .foregroundColor(Color.accentColor)
                            
                            Text("\(duration) minutes")
                        }
                    }
                }
                
                if let directors = project.attributes.directors, directors.data.count > 0 {
                    ForEach(directors.data) { director in
                        NavigationLink(destination: PersonDetailView(person: director.person)) {
                            HStack {
                                KFImage(URL(string: director.attributes.imageURL ?? "")!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading)  {
                                    Text("Director")
                                        .bold()
                                    
                                    Text("\(director.attributes.firstName) \(director.attributes.lastName)")
                                        .lineLimit(1)
                                        .foregroundColor(Color.foregroundColor)
                                }
                            }
                        }
                    }
                }
                
                
//                print("debug: \(viewModel.project.attributes.rankingCurrentRank) \(viewModel.project.attributes.rankingDifference) \(viewModel.project.attributes.rankingChangeDirection)")
                if let currentRank = project.attributes.rankingCurrentRank, let rankingDifference = project.attributes.rankingDifference, let rankingChangeDirection = project.attributes.rankingChangeDirection {
                    HStack {
                        Image(systemName: rankingChangeDirection.toImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading)  {
                            Text("Ranking")
                                .bold()
                                .foregroundColor(Color.accentColor)
                            
                            Text("\(currentRank) (\(rankingChangeDirection.toCharacter())\(rankingDifference))")
                        }
                    }
                }
            }
        }.padding(.horizontal, 20)
    }
}
