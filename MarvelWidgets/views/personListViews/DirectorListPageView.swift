//
//  DirectorListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/11/2022.
//

import Foundation
import SwiftUI

struct DirectorListPageView: View {
    @Binding var showLoader: Bool
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Menu(content: {
                ForEach(SortKeys.allCases, id: \.self){ item in
                    Button(item.rawValue, action: {
                        viewModel.sortDirectors(by: item)
                    })
                }
            }, label: {
                Text("Order by: **\(String(describing: viewModel.orderType.rawValue))**")
                Image(systemName: "arrow.up.arrow.down")
            })
            
            ScrollView {
                VStack {
                    LazyVGrid(columns: viewModel.columns, spacing: 20) {
                        ForEach(viewModel.directors) { director in
                            NavigationLink(destination: DirectorDetailView(director: director, showLoader: $showLoader)) {
                                VStack {
                                    ImageSizedView(url: director.attributes.imageURL ?? "")
                                    
                                    Text("\(director.attributes.firstName) \(director.attributes.lastName)")
                                }
                            }
                        }
                    }
                }
            }
        }.onAppear {
            Task {
                await viewModel.getDirectors()
            }
        }.navigationTitle("Directors")
    }
}
