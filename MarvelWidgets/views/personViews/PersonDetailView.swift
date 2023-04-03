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
    @Binding var showLoader: Bool
    
    @State var projects: [ProjectWrapper] = []
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
                    VStack {
                        Text("\(person.firstName) \(person.lastName)")
                            .font(Font.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        Text(person.getSubtitle())
                            .font(Font.subheadline)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        if let actor = person as? ActorPerson {
                            Text(actor.dateOfBirth?.toDate()?.toFormattedString() ?? "Unkown")
                        }
                    }
                        
                    if projects.count > 0 {
                            VStack(alignment: .center) {
                                Text(person.getProjectsTitle())
                                    .font(Font.largeTitle)
                                    .padding()
                                
                                LazyVGrid(columns: columns, spacing: 15){
                                    ForEach(projects.sorted(by: {
                                        $0.attributes.releaseDate ?? "" < $1.attributes.releaseDate ?? ""
                                    }), id: \.uuid) { project in
                                        VStack {
                                            NavigationLink {
                                                ProjectDetailView(
                                                    viewModel: ProjectDetailViewModel(
                                                        project: project
                                                    ),
                                                    showLoader: $showLoader
                                                )
                                            } label: {
                                                VStack{
                                                    ImageSizedView(url: project.attributes.posters?.first?.posterURL ?? "")
                                                    
                                                    Text(project.attributes.title)
                                                        .font(Font.headline.bold())
                                                    
                                                    Text(project.attributes.releaseDate?.toDate()?.toFormattedString() ?? "Unknown releasedate")
                                                        .font(Font.body.italic())
                                                        .foregroundColor(Color(uiColor: UIColor.label))
                                                }
                                            }
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }.padding()
                        }
                }.offset(x: 0, y: -50)
            }.onAppear {
                Task {
                    if let person = await person.getPopulated() {
                        await MainActor.run {
                            withAnimation {
                                self.person = person
                                self.projects = person.projects
                            }
                        }
                    }
                }
            }
        }).baseTintColor(Color("AccentColor"))
            .headerHeight({ _ in 500 })
    }
}
