//
//  ActorDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 14/11/2022.
//

import Foundation
import SwiftUI
import Kingfisher
import SwiftUINavigationHeader

struct PersonDetailView: View {
    @State var person: any Person
    
    @State var inSheet: Bool = false
    @State var projects: [ProjectWrapper] = []
    var onDisappearCallback: () -> Void = { }
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationHeaderContainer(bottomFadeout: true, headerAlignment: .top, header: {
            if let posterUrl = person.imageUrl?.absoluteString {
                NavigationLink(destination: FullscreenImageView(url: posterUrl)) {
                    KFImage(URL(string: posterUrl)!)
                        .resizable()
                        .scaledToFill()
                }
            }
        }, content: {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("\(person.firstName) \(person.lastName)")
                            .font(Font.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        LazyVGrid(columns: columns, alignment: .leading)  {
                            GridItemView(
                                imageName: person.getIconName(),
                                title: "Type",
                                value: person.getSubtitle()
                            )
                            
                            if let actor = person as? ActorPerson {
                                GridItemView(
                                    imageName: "person.crop.circle.fill",
                                    title: "Role",
                                    value: actor.role
                                )
                                
                                GridItemView(
                                    imageName: "calendar.circle.fill",
                                    title: "Date of birth",
                                    value: actor.dateOfBirth?.toDate()?.toFormattedString() ?? "Unkown"
                                )
                            } else if let director = person as? DirectorPerson {
                                GridItemView(
                                    imageName: "calendar.circle.fill",
                                    title: "Date of birth",
                                    value: director.dateOfBirth?.toDate()?.toFormattedString() ?? "Unkown"
                                )
                            }
                        }.padding(.horizontal, 20)
                    }
                        
                    if projects.count > 0 {
                            VStack(alignment: .center) {
                                Text(person.getProjectsTitle())
                                    .font(Font.largeTitle)
                                    .padding()
                                
                                LazyVGrid(columns: columns, spacing: 15){
                                    ForEach(projects.sorted(by: {
                                        $0.attributes.releaseDate ?? "" < $1.attributes.releaseDate ?? ""
                                    }), id: \.id) { project in
                                        VStack {
                                            NavigationLink {
                                                ProjectDetailView(
                                                    viewModel: ProjectDetailViewModel(
                                                        project: project
                                                    ),
                                                    inSheet: inSheet
                                                )
                                            } label: {
                                                PosterListViewItem(
                                                    posterUrl: project.attributes.getPosterUrls().first ?? "",
                                                    title: project.attributes.title,
                                                    subTitle: project.attributes.getReleaseDateString(),
                                                    showGradient: true
                                                )
                                            }
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }.padding()
                        }
                }.padding(.vertical, -50)
            }.task {
                if let person = await person.getPopulated() {
                    self.person = person
                    self.projects = person.projects
                }
            }.onDisappear {
                onDisappearCallback()
            }
        }).baseTintColor(Color("AccentColor"))
            .headerHeight({ _ in 500 })
            .hiddenTabBar(inSheet: inSheet)
            .task {
                let type: Page = person is ActorPerson ? .actor : .director
                await TrackingService.trackPage(page: TrackingPage(pageId: person.id, pageType: type))
            }
    }
}
