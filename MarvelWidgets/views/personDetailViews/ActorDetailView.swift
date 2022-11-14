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
    @Binding var shouldStopReload: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack {
                        if let imageUrl = actor.attributes.imageURL {
                            NavigationLink(destination: FullscreenImageView(url: imageUrl)) {
                                KFImage(URL(string: imageUrl)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 150, alignment: .center)
                                    .cornerRadius(12)
                                    .padding(.trailing, 20)
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
                    }
                }
                
                VStack {
                    Text("Directed projects")
                        .font(Font.largeTitle)
                        .padding()
                    
                    VStack(spacing: 15){
                        ForEach(actor.attributes.mcuProjects?.data ?? [], id: \.uuid) { project in
                            NavigationLink {
                                ProjectDetailView(viewModel: ProjectDetailViewModel(project: project), shouldStopReload: $shouldStopReload, showLoader: $showLoader)
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
        }.navigationTitle("\(actor.attributes.firstName) \(actor.attributes.lastName)")
    }
}
