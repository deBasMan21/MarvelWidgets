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
                        ForEach(viewModel.filteredActors, id: \.id) { actorObj in
                            NavigationLink(destination: actorObj.getDestinationView(showLoader: $showLoader)) {
                                PosterListViewItem(
                                    posterUrl: actorObj.imageUrl?.absoluteString ?? "",
                                    title: "\(actorObj.firstName) \(actorObj.lastName)",
                                    subTitle: actorObj.getSubtitle()
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
                                ForEach(viewModel.birthdayActors, id: \.id) { actor in
                                    NavigationLink(destination: actor.getDestinationView(showLoader: $showLoader)) {
                                        VStack {
                                            Text("\(actor.firstName) \(actor.lastName) (\(actor.dateOfBirth?.toDate()?.calculateAge() ?? 0))")
                                                .bold()
                                            
                                            Text("\(actor.dateOfBirth?.toDate()?.toFormattedString() ?? "")")
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
