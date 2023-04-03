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
    
    var body: some View {
        VStack{
            if viewModel.showFilters {
                VStack(spacing: 20) {
                    SearchFilterView(searchQuery: $viewModel.searchQuery)
                    
                    HStack {
                        Text("Type: ")
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(viewModel.typeFilters, id: \.rawValue) { type in
                                    Text(type.toString())
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 7)
                                        .background(viewModel.selectedTypes.contains(type) ? Color.accentColor : Color.accentGray)
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            if viewModel.selectedTypes.contains(type),
                                               let index = viewModel.selectedTypes.firstIndex(of: type) {
                                                viewModel.selectedTypes.remove(at: index)
                                            } else {
                                                viewModel.selectedTypes.append(type)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    
                    if viewModel.pageType == .mcu {
                        HStack {
                            Text("Phase: ")
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(Phase.allCases, id: \.rawValue) { phase in
                                        Text(phase.rawValue)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 7)
                                            .background(viewModel.selectedFilters.contains(phase) ? Color.accentColor : Color.accentGray)
                                            .cornerRadius(8)
                                            .onTapGesture {
                                                if viewModel.selectedFilters.contains(phase),
                                                   let index = viewModel.selectedFilters.firstIndex(of: phase) {
                                                    viewModel.selectedFilters.remove(at: index)
                                                } else {
                                                    viewModel.selectedFilters.append(phase)
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                    
                    OrderFilterView(orderType: $viewModel.orderType)
                }.padding()
            }
            
            Text("**\(viewModel.projects.count)** \(viewModel.navigationTitle)")
            
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
                        }
                    }.refreshable {
                        await viewModel.refresh(force: true)
                    }.simultaneousGesture(
                        DragGesture().onChanged({ _ in
                            withAnimation {
                                viewModel.showScroll = true
                            }
                        }))
                    
                    if viewModel.showScroll && !viewModel.forceClose {
                        FloatingActionButtonOverlay(
                            buttons: [
                                ("calendar.badge.clock", {
                                     withAnimation {
                                         reader.scrollTo(viewModel.closestDateId, anchor: .top)
                                         viewModel.showScroll = false
                                     }
                                }),
                                ("line.3.horizontal.decrease", {
                                    withAnimation {
                                        viewModel.showFilters.toggle()
                                    }
                                }),
                                ("magnifyingglass", {
                                    withAnimation {
                                        viewModel.showFilters.toggle()
                                    }
                                })
                            ]
                            
                        )
                    }
                }
            }
        }.navigationBarState(.compact, displayMode: .automatic)
            .onAppear{
                showLoader = true
                Task{
                    viewModel.pageType = pageType
                    await viewModel.fetchProjects()
                    showLoader = false
                }
            }.navigationTitle(viewModel.navigationTitle)
                .toolbar {
                    FilterToolbarButton(showFilters: $viewModel.showFilters)
                }
    }
}

struct FloatingActionButtonOverlay: View {
    @State var buttons: [(String, () -> Void)]
    
    @State var showAll: Bool = false
    @State var spacing: CGFloat = 20.0
    
    func getTransition(_ leadingIndex: Int, _ trailingIndex: Int) -> AnyTransition {
        .asymmetric(
            insertion: .opacity.animation(.spring().delay(0.1 * Double(leadingIndex))),
            removal: .opacity.animation(.spring().delay(0.1 * Double(trailingIndex)))
        )
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                VStack(spacing: spacing) {
                    Spacer()
                    
                    if showAll {
                        ForEach(Array(buttons.enumerated()), id: \.1.0) { button in
                            Image(systemName: button.1.0)
                                .multilineTextAlignment(.center)
                                .frame(width: 50, height: 50)
                                .background(Color.accentColor)
                                .clipShape(Circle())
                                .onTapGesture {
                                    button.1.1()
                                }
                                .transition(getTransition(buttons.count - 1 - button.0, button.0))
                        }
                    }
                    
                    Image(systemName: showAll ? "xmark" : "ellipsis")
                        .multilineTextAlignment(.center)
                        .frame(width: 50, height: 50)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .onTapGesture {
                            withAnimation {
                                showAll.toggle()
                            }
                        }
                }
                .padding(20)
            }
        }
    }
}

struct PosterListViewItem: View {
    @State var posterUrl: String
    @State var title: String
    @State var subTitle: String
    @State var showGradient: Bool = true
    
    var body: some View {
        ZStack {
            ImageSizedView(url: posterUrl, showGradient: showGradient)
            
            VStack {
                Spacer()
                
                VStack {
                    Text(title)
                        .font(Font.headline.bold())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(subTitle)
                        .font(Font.body.italic())

                }
            }.padding(.horizontal, 20)
                .padding(.bottom)
        }.foregroundColor(.white)
            .shadow(color: Color(uiColor: UIColor.white.withAlphaComponent(0.3)), radius: 5)
    }
}

struct SearchFilterView: View {
    @Binding var searchQuery: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $searchQuery)
                .padding(10)
            
            Image(systemName: searchQuery.isEmpty ? "magnifyingglass" : "xmark")
                .padding(.trailing, 10)
                .onTapGesture {
                    searchQuery = ""
                }
        }.overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.accentColor, lineWidth: 2)
        )
    }
}

struct OrderFilterView<T: RawRepresentable & CaseIterable>: View where T.RawValue == String {
    @Binding var orderType: T
    
    var body: some View {
        HStack {
            Text("Order by:")
            
            Spacer()
            
            Menu(content: {
                let allCases = T.allCases as? [T]
                if let allCases {
                    ForEach(allCases, id: \.self.rawValue){ (item: T) in
                        Button(item.rawValue, action: {
                            orderType = item
                        })
                    }
                }
            }, label: {
                HStack {
                    Text("\(String(describing: orderType.rawValue))")
                }.foregroundColor(Color.foregroundColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(Color.accentGray)
                    .cornerRadius(8)
            })
        }
    }
}

struct FilterToolbarButton: View {
    @Binding var showFilters: Bool
    
    var body: some View {
        Button {
            withAnimation {
                showFilters.toggle()
            }
        } label: {
            HStack {
                Text("Filters")
                Image(systemName: showFilters ? "xmark" : "line.3.horizontal.decrease")
                    .frame(width: 24, height: 24)
            }
        }.tint(.accentColor)
            .foregroundColor(.accentColor)
            .navigationBarState(.compact, displayMode: .automatic)
    }
}
