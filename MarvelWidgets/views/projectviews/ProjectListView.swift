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
                
                List(viewModel.projects, id: \.id) { item in
                    NavigationLink {
                        ProjectDetailView(project: item)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(Font.headline.bold())
                            
                            Text(item.releaseDate ?? "Unknown releasedate")
                                .font(Font.body.italic())
                        }
                    }
                }.onAppear {
                    let tableHeaderView = UIView(frame: .zero)
                    tableHeaderView.frame.size.height = 1
                    UITableView.appearance().tableHeaderView = tableHeaderView
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
