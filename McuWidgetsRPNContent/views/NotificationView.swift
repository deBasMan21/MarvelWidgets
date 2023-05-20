//
//  NotificationView.swift
//  McuWidgetsRPNContent
//
//  Created by Bas Buijsen on 20/05/2023.
//

import SwiftUI
import UserNotifications

struct NotificationView: View {
    @State var img: UIImage?
    @State var projectId: Int
    @State var title: String
    @State var bodyText: String
    
    @State var project: ProjectWrapper? = nil
    
    var body: some View {
        VStack {
            if let img = img {
                Image(uiImage: img)
                    .frame(height: 300)
                    .scaledToFill()
                    .clipped()
            }
            
            if let project = project {
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
                        
                    }
                }
            }
            
            Text(title)
                .bold()
                .font(.system(size: 24))
            
            Text(bodyText)
                .multilineTextAlignment(.center)
                .lineLimit(3)
            
            Spacer()
        }.frame(height: 550)
            .onAppear {
                Task {
                    project = await ProjectService.getById(projectId)
                }
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
