//
//  ContentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State var showSheet: Bool = false
    @State var showLoader = false
    
    @State var showView = false
    
    @State var detailView: ProjectDetailView?
    
    var body: some View {
        ZStack {
            TabView {
                NavigationView {
                    ProjectListView(type: .all, showLoader: $showLoader)
                }.tabItem{
                    Label("All", systemImage: "list.dash")
                }
                
                NavigationView {
                    ProjectListView(type: .movies, showLoader: $showLoader)
                }.tabItem{
                    Label("Movies", systemImage: "film")
                }
                
                NavigationView {
                    ProjectListView(type: .series, showLoader: $showLoader)
                }.tabItem{
                    Label("Series", systemImage: "tv")
                }
                
                NavigationView {
                    ProjectListView(type: .special, showLoader: $showLoader)
                }.tabItem{
                    Label("Specials", systemImage: "star.circle.fill")
                }
                
                if UserDefaultsService.standard.showOtherTabs {
                    MoreMenuView(showLoader: $showLoader)
                    .tabItem {
                        Label("More", systemImage: "ellipsis")
                    }
                } else {
                    NavigationView {
                        WidgetSettingsView()
                    }.tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
                
            }.onOpenURL(perform: { url in
                if url.scheme == "mcuwidgets" {
                    if url.host == "project" {
                        let id = Int(url.lastPathComponent) ?? -1
                        self.detailView = ProjectDetailView(
                            viewModel: ProjectDetailViewModel(
                                project: ProjectWrapper(
                                    id: id,
                                    attributes: MCUProject(
                                        title: "Loading...",
                                        releaseDate: nil,
                                        postCreditScenes: nil,
                                        duration: nil,
                                        phase: .unkown,
                                        saga: .infinitySaga,
                                        overview: nil,
                                        type: .movie,
                                        boxOffice: nil,
                                        createdAt: nil,
                                        updatedAt: nil,
                                        disneyPlusUrl: nil,
                                        directors: nil,
                                        actors: nil,
                                        relatedProjects: nil,
                                        trailers: nil,
                                        posters: nil,
                                        seasons: nil
                                    )
                                )
                            ),
                            showLoader: $showLoader
                        )
                        
                        self.showSheet = true
                    }
                }
            }).disabled(showLoader)
                .sheet(isPresented: $showSheet) {
                    VStack {
                        if showView {
                            NavigationView {
                                detailView
                                    .navigationBarItems(leading:
                                        Button("Close", action: {
                                            showSheet = false
                                        })
                                    )
                            }
                        } else {
                            ProgressView()
                                .onAppear {
                                    Task {
                                        try? await Task.sleep(nanoseconds: 1000000000)
                                        showView = true
                                    }
                                }
                        }
                    }
                }
            if showLoader {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        ProgressView()
                            .padding(10)
                            .background(.red)
                            .cornerRadius(10)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }.background(.black.opacity(0.7))
                    .transition(.opacity)
            }
        }
    }
}
