//
//  SmallWidgetUpcomingSmallView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/08/2022.
//

import Foundation
import SwiftUI

struct SmallWidgetUpcomingMedium: View {
    let upcomingProject: Project
    let image: Image
    
    var body: some View {
        HStack(spacing: 20) {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(upcomingProject.title)
                    .foregroundColor(Color("AccentColor"))
                    .fontWeight(.bold)
                
                VStack(alignment: .leading) {
                    Text("Releasedate")
                        .font(Font.body.italic())
                    
                    Text(getReleaseDateString(upcomingProject: upcomingProject))
                        .fontWeight(.bold)
                }
                
                VStack(alignment: .leading) {
                    Text("Director")
                        .font(Font.body.italic())
                    
                    Text(getDirectorString(upcomingProject: upcomingProject))
                        .fontWeight(.bold)
                }
            }
            
            Spacer()
        }.widgetURL(URL(string: "marvelwidgets://project/\(upcomingProject.getUniqueProjectId())")!)
    }
    
    func getReleaseDateString(upcomingProject: Project) -> String {
        if let difference = upcomingProject.releaseDate?.toDate()?.differenceInDays(from: Date.now), difference >= 0 {
            return "\(upcomingProject.releaseDate!) (\(difference) days)"
        } else {
            return upcomingProject.releaseDate ?? "No releasedate"
        }
    }

    func getDirectorString(upcomingProject: Project) -> String {
        if let director = upcomingProject.directedBy, !director.isEmpty {
            return director
        } else {
            return "No director yet"
        }
    }
}
