//
//  ProjectListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation
import SwiftUI

struct ProjectListView: View {
    @State var type: WidgetType
    @StateObject var viewModel = ProjectListViewModel()
    @Binding var showLoader: Bool
    
    var body: some View {
        NavigationView {
            VStack{
                Menu(content: {
                    ForEach(OrderType.allCases, id: \.self){ item in
                        Button(item.rawValue, action: {
                            viewModel.orderProjects(by: item)
                        })
                    }
                }, label: {
                    Text("Order by: **\(String(describing: viewModel.orderType.rawValue))**")
                    Image(systemName: "arrow.up.arrow.down")
                })
                
                Text("**\(viewModel.projects.count)** \(viewModel.navigationTitle)")
                
                ScrollView {
                    ForEach(viewModel.projects, id: \.id) { item in
                        NavigationLink {
                            ProjectDetailView(
                                viewModel: ProjectDetailViewModel(
                                    project: item
                                ),
                                showLoader: $showLoader
                            )
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.attributes.title)
                                        .font(Font.headline.bold())
                                        .multilineTextAlignment(.leading)
                                    
                                    Text(item.attributes.releaseDate ?? "Unknown releasedate")
                                        .font(Font.body.italic())
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }.padding()
                                .foregroundColor(Color(uiColor: UIColor.label))
                                .background(Color("ListItemBackground"))
                                .cornerRadius(20)
                                .padding(.horizontal)
                        }
                    }
                }.refreshable {
                    Task {
                        await viewModel.refresh()
                    }
                }
                
            }.navigationTitle(viewModel.navigationTitle)
        }.onAppear{
            Task{
                viewModel.pageType = type
                await viewModel.fetchProjects()
            }
        }
    }
}
