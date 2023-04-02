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

struct ActorDetailView: View {
    @State var actor: ActorsWrapper
    @State var projects: [ProjectWrapper] = []
    @Binding var showLoader: Bool
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationHeaderContainer(bottomFadeout: true, headerAlignment: .top, header: {
            if let posterUrl = actor.attributes.imageURL {
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
                        Text("\(actor.attributes.firstName) \(actor.attributes.lastName)")
                            .font(Font.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        Text(actor.attributes.character)
                            .font(Font.subheadline)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        Text(actor.attributes.dateOfBirth?.toDate()?.toFormattedString() ?? "Unkown")
                    }
                        
                    if projects.count > 0 {
                            VStack(alignment: .center) {
                                Text("Played in")
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
                    if let populatedActor = await ProjectService.getActorById(id: actor.id) {
                        await MainActor.run {
                            withAnimation {
                                self.actor = populatedActor
                                
                                var projectsList: [ProjectWrapper] = []
                                if let mcuProjects = populatedActor.attributes.mcuProjects {
                                    projectsList += mcuProjects.data
                                }
                                    
                                if let relatedProjects = populatedActor.attributes.relatedProjects {
                                    projectsList += relatedProjects.data
                                }
                                
                                self.projects = projectsList
                            }
                        }
                    }
                }
            }
        }).baseTintColor(Color("AccentColor"))
            .headerHeight({ _ in 500 })
    }
}
