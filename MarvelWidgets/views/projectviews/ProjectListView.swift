//
//  ProjectListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation
import SwiftUI
import ScrollViewIfNeeded

struct ProjectListView: View {
    @StateObject var viewModel = ProjectListViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: viewModel.columns, spacing: 20)  {
                    ForEach(viewModel.projects, id: \.id) { item in
                        NavigationLink {
                            ProjectDetailView(
                                viewModel: ProjectDetailViewModel(
                                    project: item
                                ),
                                inSheet: false
                            )
                        } label: {
                            PosterListViewItem(
                                posterUrl: item.attributes.getPosterUrls().first ?? "",
                                title: item.attributes.title,
                                subTitle: item.attributes.getReleaseDateString(),
                                showGradient: true
                            )
                        }.id(item.id)
                    }
                }
            }.searchable(text: $viewModel.searchQuery)
                .refreshable {
                    await viewModel.refresh(force: true)
                }
        }.task {
            if viewModel.projects.count <= 0 {
                await viewModel.fetchProjects()
            }
        }.navigationTitle("Marvel Projects")
            .navigationBarTitleDisplayMode(.large)
            .showTabBar()
            .sheet(isPresented: $viewModel.showFilters) {
                ProjectFilterSheet(viewModel: viewModel)
            }.overlay {
                FloatingActionButtonOverlay(
                    buttons: [
                        OptionCircleButton(imageName: "line.3.horizontal.decrease", clickEvent: {
                            withAnimation {
                                viewModel.showFilters.toggle()
                            }
                        }, getFunction: { function in
                            viewModel.filterCallback = function
                        })
                    ]
                )
            }
    }
}

struct ProjectFilterSheet: View {
    @StateObject var viewModel: ProjectListView.ProjectListViewModel
    
    var body: some View {
        ScrollViewIfNeeded {
            VStack {
                Text("Filters and Sorting")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TypeFilter(title: "Source", values: ProjectSource.allCases, selectedTypes: $viewModel.selectedSources)
                
                TypeFilter(
                    title: "Type",
                    values: ProjectType.allCases,
                    selectedTypes: $viewModel.selectedTypes
                )
                
                CategoryFilterView(selectedCategories: $viewModel.selectedCategories)
                
                // Date filters
                DateFilter(date: $viewModel.afterDate, title: "After:")
                
                DateFilter(date: $viewModel.beforeDate, title: "Before:")
                
                OrderFilterView(orderType: $viewModel.orderType)
                
                Button(action: {
                    viewModel.resetFilters()
                }, label: {
                    Text("Reset")
                })
            }.padding(.horizontal)
        }.presentationDetents([.medium])
            .presentationDragIndicator(.visible)
    }
}
