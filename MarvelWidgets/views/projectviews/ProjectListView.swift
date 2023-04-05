//
//  ProjectListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation
import SwiftUI

struct ProjectListView: View {
    @State var pageType: ListPageType
    @StateObject var viewModel = ProjectListViewModel()
    @Binding var showLoader: Bool
    @EnvironmentObject var remoteConfig: RemoteConfigWrapper
    
    @State private var scrollViewHeight: CGFloat = 0
    @State private var proportion: CGFloat = 0
    @State private var proportionName: String = "scroll"
    
    var body: some View {
        VStack{
            Text("**\(viewModel.projects.count)** \(viewModel.navigationTitle)")
                .sheet(isPresented: $viewModel.showFilters) {
                    AutoSizingSheet(spacing: 20, padding: true) {
                        Text("Filters and Sorting")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                        
                        TypeFilter(typeFilters: $viewModel.typeFilters, selectedTypes: $viewModel.selectedTypes)
                        
                        if viewModel.pageType == .mcu {
                            PhaseFilter(selectedFilters: $viewModel.selectedFilters)
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
                    }
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
                                        showLoader: $showLoader
                                    )
                                } label: {
                                    PosterListViewItem(
                                        posterUrl: item.attributes.posters?.first?.posterURL ?? "",
                                        title: item.attributes.title,
                                        subTitle: item.attributes.releaseDate?.toDate()?.toFormattedString() ?? "Unknown releasedate",
                                        showGradient: true)
                                }.id(item.id)
                            }
                        }.modifier(ScrollReadVStackModifier(scrollViewHeight: $scrollViewHeight, proportion: $proportion, proportionName: proportionName))
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
            }.modifier(ScrollReadScrollViewModifier(scrollViewHeight: $scrollViewHeight, proportionName: proportionName))
            
            ProgressView(value: proportion, total: 1)
        }.navigationBarState(.compact, displayMode: .automatic)
            .onAppear{
                showLoader = true
                Task{
                    viewModel.pageType = pageType
                    await viewModel.fetchProjects()
                    showLoader = false
                }
            }.navigationTitle(viewModel.navigationTitle)
            .showTabBar(featureFlag: remoteConfig.hideTabbar)
    }
}
