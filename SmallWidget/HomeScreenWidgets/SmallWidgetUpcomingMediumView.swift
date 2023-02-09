//
//  SmallWidgetUpcomingSmallView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/08/2022.
//

import Foundation
import SwiftUI

struct SmallWidgetUpcomingMedium: View {
    let upcomingProject: ProjectWrapper
    let image: Image
    
    var body: some View {
        HStack(spacing: 20) {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(upcomingProject.attributes.title)
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
        }.widgetURL(URL(string: "mcuwidgets://project/\(upcomingProject.id)")!)
    }
    
    func getReleaseDateString(upcomingProject: ProjectWrapper) -> String {
        if let difference = upcomingProject.attributes.releaseDate?.toDate()?.differenceInDays(from: Date.now), difference >= 0 {
            return "\(upcomingProject.attributes.releaseDate!) (\(difference) days)"
        } else {
            return upcomingProject.attributes.releaseDate ?? "No releasedate"
        }
    }

    func getDirectorString(upcomingProject: ProjectWrapper) -> String {
        if let director = upcomingProject.attributes.directors?.data.map({ director in
            return "\(director.attributes.firstName) \(director.attributes.lastName)"
        }).joined(separator: ", "), !director.isEmpty {
            return director
        } else {
            return "No director yet"
        }
    }
}
