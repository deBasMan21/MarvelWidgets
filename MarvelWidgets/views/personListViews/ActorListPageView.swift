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
        }.onAppear {
            Task {
                await viewModel.getActors()
            }
        }.navigationTitle("Actors")
    }
}
