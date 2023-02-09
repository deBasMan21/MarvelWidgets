//
//  ProjectListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation
import SwiftUI

struct ProjectListView: View {
    @State var type: WidgetType?
    @State var otherType: ProjectType?
    @StateObject var viewModel = ProjectListViewModel()
    @Binding var showLoader: Bool
    
    var body: some View {
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
                                                
                                                Text(item.attributes.releaseDate ?? "Unknown releasedate")
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
                            HStack {
                                Text("To now")
                                    .onTapGesture {
                                        withAnimation {
                                            reader.scrollTo(viewModel.closestDateId, anchor: .top)
                                            viewModel.showScroll = false
                                        }
                                    }
                            }.padding(.horizontal)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .cornerRadius(50)
                                .padding(.top, 20)
                            
                            Spacer()
                        }
                    }
                }
            }
        }.onAppear{
            showLoader = true
            Task{
                if let type = type {
                    viewModel.pageType = type
                } else if let otherType = otherType {
                    viewModel.relatedPageType = otherType
                }
                await viewModel.fetchProjects()
                showLoader = false
            }
        }.navigationTitle(viewModel.navigationTitle)
    }
}
