//
//  ProjectListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation
import SwiftUI

struct ProjectListView: View {
    @Binding var activeProject: [Int: Bool]
    @State var type: WidgetType
    @StateObject var viewModel = ProjectListViewModel()
    @Binding var shouldStopReload: Bool
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
                        NavigationLink(isActive: binding(for: item.id)) {
                            ProjectDetailView(
                                viewModel: ProjectDetailViewModel(
                                    project: item
                                ),
                                shouldStopReload: $shouldStopReload,
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
    
    private func binding(for key: Int) -> Binding<Bool> {
        return .init(
            get: { self.activeProject[key, default: false] },
            set: {
                if $0 {
                    withAnimation {
                        showLoader = true
                    }
                }
                self.activeProject[key] = $0
                
            })
    }
}
