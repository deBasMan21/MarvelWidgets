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
    @StateObject var viewModel: ProjectListViewModel
    @EnvironmentObject var remoteConfig: RemoteConfigWrapper
    
    init(pageType: ListPageType) {
        self._viewModel = StateObject(wrappedValue: ProjectListViewModel(pageType: pageType))
    }
    
    var body: some View {
        VStack {
            Text("**\(viewModel.projects.count)** \(viewModel.navigationTitle)")
                .sheet(isPresented: $viewModel.showFilters) {
                    ScrollViewIfNeeded {
                        VStack {
                            Text("Filters and Sorting")
                                .font(.largeTitle)
                                .bold()
                                .padding()
                            
                            TypeFilter(typeFilters: $viewModel.typeFilters, selectedTypes: $viewModel.selectedTypes)
                            
                            if viewModel.pageType == .mcu {
                                PhaseFilter(selectedFilters: $viewModel.selectedFilters)
                                
                                CategoryFilterView(selectedCategories: $viewModel.selectedCategories)
                            }
                            
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
            
            ScrollViewReader { reader in
                ZStack {
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
                                        posterUrl: item.attributes.posters?.first?.posterURL ?? "",
                                        title: item.attributes.title,
                                        subTitle: item.attributes.getReleaseDateString(),
                                        showGradient: true
                                    )
                                }.id(item.id)
                            }
                        }.modifier(ScrollReadVStackModifier(scrollViewHeight: $viewModel.scrollViewHeight, proportion: $viewModel.proportion, proportionName: viewModel.proportionName))
                    }.searchable(text: $viewModel.searchQuery)
                        .refreshable {
                            await viewModel.refresh(force: true)
                        }.simultaneousGesture(
                            DragGesture().onChanged({ _ in
                                withAnimation {
                                    viewModel.showScroll = true
                                    viewModel.scrollCallback(true, 0)
                                }
                            })
                        )
                    
                    FloatingActionButtonOverlay(
                        buttons: [
                            OptionCircleButton(imageName: "calendar.badge.clock", clickEvent: {
                                withAnimation {
                                    reader.scrollTo(viewModel.closestDateId, anchor: .top)
                                    viewModel.scrollCallback(false, 0)
                                }
                            }, getFunction: { function in
                                viewModel.scrollCallback = function
                            }),
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
            }.modifier(ScrollReadScrollViewModifier(scrollViewHeight: $viewModel.scrollViewHeight, proportionName: viewModel.proportionName))
            
            ProgressView(value: viewModel.proportion, total: 1)
        }.navigationBarState(.compact, displayMode: .automatic)
            .onAppear{
                if viewModel.projects.count <= 0 {
                    Task {
                        await viewModel.fetchProjects()
                    }
                }
            }.navigationTitle(viewModel.navigationTitle)
            .showTabBar(featureFlag: remoteConfig.hideTabbar)
    }
}
