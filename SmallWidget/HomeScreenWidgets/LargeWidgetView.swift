//
//  LargeWidgetView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 06/04/2023.
//

import Foundation
import SwiftUI

struct LargeWidgetView: View {
    @State var project: ProjectWrapper
    @State var image: Image
    
    let gradient = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color("BackgroundColor"), location: 0.0),
                .init(color: .clear, location: 0.2)
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
    
    var body: some View {
        VStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: WidgetHelper.widgetSize(forFamily: .systemLarge).height / 1.7)
                .clipped()
                .overlay(gradient)
            
            VStack {
                Text(project.attributes.title)
                    .fontWeight(.bold)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                
                if let categoriesString = project.attributes.categories {
                    HStack {
                        ForEach(categoriesString.split(separator: ", ").compactMap { String($0) }.prefix(3), id: \.hashValue) { category in
                            Text(category)
                                .textStyle(RedChipText())
                                .font(.system(size: 14))
                                .fixedSize(horizontal: true, vertical: false)
                        }
                    }.padding(.horizontal)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], alignment: .leading, spacing: 10) {
                    WidgetItemView(imageName: "calendar.circle.fill", title: "Releasedate", value: project.attributes.getReleaseDateString(withDayCount: false))
                    
                    WidgetItemView(imageName: "person.circle.fill", title: "Director", value: getDirectorString(upcomingProject: project))
                    
                    WidgetItemView(imageName: project.attributes.type.imageString(), title: "Type", value: project.attributes.type.toString())
                    
                    if let date = project.attributes.getDaysUntilRelease(withDaysString: true) {
                        WidgetItemView(imageName: "clock.fill", title: "Releases in", value: date)
                    } else if let duration = project.attributes.duration {
                        WidgetItemView(imageName: "clock.fill", title: "Duration", value: "\(duration) minutes")
                    } else if let rating = project.attributes.rating {
                        WidgetItemView(imageName: "star.circle.fill", title: "Rating", value: "\(rating)/10")
                    }
                    
                }.padding(.horizontal)
            }.padding(.top, -20)
            
            Spacer()
        }.frame(width: WidgetHelper.widgetSize(forFamily: .systemLarge).width, height: WidgetHelper.widgetSize(forFamily: .systemLarge).height)
            .widgetURL(project.getUrl())
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        
                        Image("AppIconLarge")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                            .padding(7)
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
