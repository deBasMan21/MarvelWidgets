//
//  DirectorDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 14/11/2022.
//

import Foundation
import SwiftUI
import Kingfisher

struct DirectorDetailView: View {
    @State var director: DirectorsWrapper
    @Binding var showLoader: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        VStack {
                            if let imageUrl = director.attributes.imageURL {
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
                                Text("\(director.attributes.firstName) \(director.attributes.lastName)")
                            }
                            
                            VStack(alignment: .leading) {
                                Text("**Date of birth**")
                                Text(director.attributes.dateOfBirth ?? "Unkown")
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                
                if let mcuProjects = director.attributes.mcuProjects?.data, mcuProjects.count > 0 {
                    VStack {
                        Text("Directed MCU projects")
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
                                        
                                        Text(project.attributes.releaseDate ?? "Unknown releasedate")
                                            .font(Font.body.italic())
                                            .foregroundColor(Color(uiColor: UIColor.label))
                                    }
                                }
                            }
                        }
                    }.padding()
                }
                
                
                if let relatedProjects = director.attributes.relatedProjects?.data, relatedProjects.count > 0 {
                    VStack {
                        Text("Directed related projects")
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
                                        
                                        Text(project.attributes.releaseDate ?? "Unknown releasedate")
                                            .font(Font.body.italic())
                                            .foregroundColor(Color(uiColor: UIColor.label))
                                    }
                                }
                            }
                        }
                    }.padding()
                }
            }.navigationTitle("\(director.attributes.firstName) \(director.attributes.lastName)")
        }
    }
}
