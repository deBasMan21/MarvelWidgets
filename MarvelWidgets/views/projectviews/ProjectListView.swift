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
                    HStack {
                        TextField("Search", text: $viewModel.searchQuery)
                            .padding(10)
                        
                        Image(systemName: viewModel.searchQuery.isEmpty ? "magnifyingglass" : "xmark")
                            .padding(.trailing, 10)
                            .onTapGesture {
                                viewModel.searchQuery = ""
                            }
                    }.overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.accentColor, lineWidth: 2)
                    )
                    
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
                    // Date filters work but filters get too big with them
//                    HStack {
//                        Text("After date:")
//
//                        Spacer()
//
//                        DatePicker(selection: $viewModel.afterDate, displayedComponents: .date) {
//                                        Text("")
//                                    }
//                    }
//
//                    HStack {
//                        Text("Before date:")
//
//                        Spacer()
//
//                        DatePicker(selection: $viewModel.beforeDate, displayedComponents: .date) {
//                                        Text("")
//                                    }
//                    }
                    
                    
                    HStack {
                        Text("Order by:")
                        
                        Spacer()
                        
                        Menu(content: {
                            ForEach(OrderType.allCases, id: \.self){ item in
                                Button(item.rawValue, action: {
                                    viewModel.orderProjects(by: item)
                                })
                            }
                        }, label: {
                            HStack {
                                Text("\(String(describing: viewModel.orderType.rawValue))")
                            }.foregroundColor(Color.foregroundColor)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 7)
                                .background(Color.accentGray)
                                .cornerRadius(8)
                        })
                    }
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
                                    ZStack {
                                        ImageSizedView(url: item.attributes.posters?.first?.posterURL ?? "", showGradient: true)
                                        
                                        VStack {
                                            Spacer()
                                            
                                            VStack {
                                                Text(item.attributes.title)
                                                    .font(Font.headline.bold())
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(2)
                                                
                                                Text(item.attributes.releaseDate?.toDate()?.toFormattedString() ?? "Unknown releasedate")
                                                    .font(Font.body.italic())

                                            }
                                        }.padding(.horizontal, 20)
                                            .padding(.bottom)
                                    }.foregroundColor(.white)
                                        .shadow(color: Color(uiColor: UIColor.white.withAlphaComponent(0.3)), radius: 5)
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
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Image(systemName: "calendar.badge.clock")
                                    .multilineTextAlignment(.center)
                                    .frame(width: 50, height: 50)
                                    .background(Color.accentColor)
                                    .clipShape(Circle())
                                    .padding(20)
                                    .onTapGesture {
                                        withAnimation {
                                            reader.scrollTo(viewModel.closestDateId, anchor: .top)
                                            viewModel.showScroll = false
                                        }
                                    }
                            }
                        }
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
                Button {
                    withAnimation {
                        viewModel.showFilters.toggle()
                    }
                } label: {
                    HStack {
                        Text("Filters")
                        Image(systemName: viewModel.showFilters ? "xmark" : "line.3.horizontal.decrease")
                            .frame(width: 24, height: 24)
                    }
                }.tint(.accentColor)
                    .foregroundColor(.accentColor)
                    .navigationBarState(.compact, displayMode: .automatic)
            }
    }
}
