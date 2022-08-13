//
//  ProjectListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation
import SwiftUI

struct ProjectListView: View {
    @Binding var activeProject: [String: Bool]
    @State var type: WidgetType
    @StateObject var viewModel = ProjectListViewModel()
    @Binding var shouldStopReload: Bool
    
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
                    PullToRefreshView(coordinateSpaceName: "\(viewModel.pageType.rawValue)-list", onRefresh: {
                        Task {
                            await viewModel.refresh()
                        }
                    })
                    ForEach(viewModel.projects, id: \.id) { item in
                        NavigationLink(isActive: binding(for: item.getUniqueProjectId())) {
                            ProjectDetailView(viewModel: ProjectDetailViewModel(project: item))
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(Font.headline.bold())
                                        .multilineTextAlignment(.leading)
                                    
                                    Text(item.releaseDate ?? "Unknown releasedate")
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
                    }.onAppear {
                        let tableHeaderView = UIView(frame: .zero)
                        tableHeaderView.frame.size.height = 1
                        UITableView.appearance().tableHeaderView = tableHeaderView
                    }
                }.coordinateSpace(name: "\(viewModel.pageType.rawValue)-list")
                
            }.navigationTitle(viewModel.navigationTitle)
        }.onAppear{
            if !shouldStopReload {
                Task{
                    viewModel.pageType = type
                    await viewModel.fetchProjects()
                }
            } else {
                shouldStopReload = false
            }
        }
    }
    
    private func binding(for key: String) -> Binding<Bool> {
        return .init(
            get: { self.activeProject[key, default: false] },
            set: { self.activeProject[key] = $0 })
    }
}
