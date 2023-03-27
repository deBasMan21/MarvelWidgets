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
            Menu(content: {
                ForEach(SortKeys.allCases, id: \.self){ item in
                    Button(item.rawValue, action: {
                        viewModel.sortActors(by: item)
                    })
                }
            }, label: {
                Text("Order by: **\(String(describing: viewModel.orderType.rawValue))**")
                Image(systemName: "arrow.up.arrow.down")
            })
            
            ScrollView {
                VStack {
                    LazyVGrid(columns: viewModel.columns, spacing: 20) {
                        ForEach(viewModel.actors) { actorObj in
                            NavigationLink(destination: ActorDetailView(actor: actorObj, showLoader: $showLoader)) {
                                VStack {
                                    ImageSizedView(url: actorObj.attributes.imageURL ?? "")
                                    
                                    Text("\(actorObj.attributes.firstName) \(actorObj.attributes.lastName)")
                                }
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
