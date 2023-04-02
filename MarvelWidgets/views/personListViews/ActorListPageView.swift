//
//  ActorListPageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/11/2022.
//

import Foundation
import SwiftUI

struct ActorListPageView: View {
    @Binding var showLoader: Bool
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                SearchFilterView(searchQuery: $viewModel.filterSearchQuery)
                
                OrderFilterView(orderType: $viewModel.orderType)
            }.padding()
            
            Text("**\(viewModel.filteredActors.count)** Actors")
            
            ScrollView {
                VStack {
                    LazyVGrid(columns: viewModel.columns, spacing: 20) {
                        ForEach(viewModel.filteredActors) { actorObj in
                            NavigationLink(destination: ActorDetailView(actor: actorObj, showLoader: $showLoader)) {
                                PosterListViewItem(
                                    posterUrl: actorObj.attributes.imageURL ?? "",
                                    title: "\(actorObj.attributes.firstName) \(actorObj.attributes.lastName)",
                                    subTitle: actorObj.attributes.character
                                )
                            }
                        }
                    }
                }
            }
            
            if viewModel.birthdayActors.count > 0 && viewModel.showBirthdays {
                HStack {
                    Text("Today's \nbirthday:")
                    
                    GeometryReader { geometry in
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.birthdayActors) { actor in
                                    NavigationLink(destination: ActorDetailView(actor: actor, showLoader: $showLoader)) {
                                        VStack {
                                            Text("\(actor.attributes.firstName) \(actor.attributes.lastName) (\(actor.attributes.dateOfBirth?.toDate()?.calculateAge() ?? 0))")
                                                .bold()
                                            
                                            Text("\(actor.attributes.dateOfBirth?.toDate()?.toFormattedString() ?? "")")
                                                .foregroundColor(.white)
                                        }.padding()
                                            .background(Color.accentGray)
                                            .cornerRadius(10)
                                    }
                                }
                            }.frame(width: geometry.size.width)
                        }
                    }.frame(height: 75)
                    
                    Image(systemName: "xmark")
                        .onTapGesture {
                            withAnimation {
                                viewModel.showBirthdays = false
                            }
                        }
                }.padding(3)
            }
        }.onAppear {
            Task {
                await viewModel.getActors()
            }
        }.navigationTitle("Actors")
    }
}
