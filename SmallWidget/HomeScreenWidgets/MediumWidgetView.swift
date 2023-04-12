//
//  SmallWidgetUpcomingSmallView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/08/2022.
//

import Foundation
import SwiftUI

struct MediumWidgetView: View {
    let upcomingProject: ProjectWrapper
    let image: Image
    
    let gradient = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color("BackgroundColor"), location: 0.0),
                .init(color: .clear, location: 0.2)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(upcomingProject.attributes.title)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)
                
                WidgetItemView(imageName: "calendar.circle.fill", title: "Releasedate", value: upcomingProject.attributes.getReleaseDateString(withDayCount: true))
                
                WidgetItemView(imageName: upcomingProject.attributes.type.imageString(), title: "Type", value: upcomingProject.attributes.type.toString())
                
                WidgetItemView(imageName: "person.circle.fill", title: "Director", value: getDirectorString(upcomingProject: upcomingProject))
                
                Spacer()
            }.padding(10)
            
            Spacer()
            
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120)
                .clipped()
                .overlay(gradient)
        }.frame(width: WidgetHelper.widgetSize(forFamily: .systemMedium).width, height: WidgetHelper.widgetSize(forFamily: .systemMedium).height)
            .widgetURL(upcomingProject.getUrl())
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        
                        Image("AppIconLarge")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                            .padding(5)
                    }
                    
                    Spacer()
                }
            )
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

struct WidgetItemView: View {
    @State var imageName: String
    @State var title: String
    @State var value: String
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.italic(.system(size: 9))())
                    .foregroundColor(Color("AccentColor"))
                
                Text(value)
                    .font(.system(size: 13))
                    .lineLimit(1)
            }
        }
    }
}
