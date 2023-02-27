//
//  ActorDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 14/11/2022.
//

import Foundation
import SwiftUI
import Kingfisher

struct ActorDetailView: View {
    @State var actor: ActorsWrapper
    @Binding var showLoader: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        VStack {
                            if let imageUrl = actor.attributes.imageURL {
                                NavigationLink(destination: FullscreenImageView(url: imageUrl)) {
                                    KFImage(URL(string: imageUrl)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150)
                                        .cornerRadius(12)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            VStack(alignment: .leading) {
                                Text("**Name**")
                                Text("\(actor.attributes.firstName) \(actor.attributes.lastName)")
                            }
                            
                            VStack(alignment: .leading) {
                                Text("**Date of birth**")
                                Text(actor.attributes.dateOfBirth ?? "Unkown")
                            }
                            
                            VStack(alignment: .leading) {
                                Text("**Role**")
                                Text(actor.attributes.character)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                if let mcuProjects = actor.attributes.mcuProjects?.data, mcuProjects.count > 0 {
                    VStack(alignment: .center) {
                        Text("Played in MCU projects")
                            .font(Font.title2)
                            .padding()
                        
                        VStack(spacing: 15){
                            ForEach(mcuProjects, id: \.uuid) { project in
                                NavigationLink {
                                    ProjectDetailView(
                                        viewModel: ProjectDetailViewModel(
                                            project: project
                                        ),
                                        showLoader: $showLoader
                                    )
                                } label: {
                                    VStack{
                                        Text(project.attributes.title)
                                            .font(Font.headline.bold())
                                        
                                        Text(project.attributes.releaseDate?.toDate()?.toFormattedString() ?? "Unknown releasedate")
                                            .font(Font.body.italic())
                                            .foregroundColor(Color(uiColor: UIColor.label))
                                    }
                                }
                            }
                        }
                    }.padding()
                }
                
                if let relatedProjects = actor.attributes.relatedProjects?.data, relatedProjects.count > 0 {
                    VStack(alignment: .center) {
                        Text("Played in")
                            .font(Font.title2)
                            .padding()
                        
                        VStack(spacing: 15){
                            ForEach(relatedProjects, id: \.uuid) { project in
                                NavigationLink {
                                    ProjectDetailView(
                                        viewModel: ProjectDetailViewModel(
                                            project: project
                                        ),
                                        showLoader: $showLoader
                                    )
                                } label: {
                                    VStack{
                                        Text(project.attributes.title)
                                            .font(Font.headline.bold())
                                        
                                        Text(project.attributes.releaseDate?.toDate()?.toFormattedString() ?? "Unknown releasedate")
                                            .font(Font.body.italic())
                                            .foregroundColor(Color(uiColor: UIColor.label))
                                    }
                                }
                            }
                        }
                    }.padding()
                }
            }.navigationTitle("\(actor.attributes.firstName) \(actor.attributes.lastName)")
        }
    }
}
