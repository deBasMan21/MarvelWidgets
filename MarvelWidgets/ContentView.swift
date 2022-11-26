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
                ProjectListView(type: .all, showLoader: $showLoader)
                    .tabItem{
                        Label("All", systemImage: "list.dash")
                    }.tag(0)
                
                ProjectListView(type: .movies, showLoader: $showLoader)
                    .tabItem{
                        Label("Movies", systemImage: "film")
                    }.tag(1)
                
                ProjectListView(type: .series, showLoader: $showLoader)
                    .tabItem{
                        Label("Series", systemImage: "tv")
                    }.tag(2)
                
                ProjectListView(type: .special, showLoader: $showLoader)
                    .tabItem{
                        Label("Specials", systemImage: "star.circle.fill")
                    }.tag(3)
                
                if UserDefaultsService.standard.showOtherTabs {
                    Text("Fox (xmen, fantastic four, deadpool etc.)")
                        .tabItem {
                            Label("Fox", systemImage: "film")
                        }
                    
                    Text("Defenders (daredevil, luke cage, jessica jones etc.)")
                        .tabItem {
                            Label("Defenders universe", systemImage: "film")
                        }
                    
                    Text("Sony (spiderman, amazing spiderman, venom etc.)")
                        .tabItem {
                            Label("Sony films", systemImage: "film")
                        }
                    
                    Text("Marvel television (agents of shield, agent carter)")
                        .tabItem {
                            Label("Marvel television", systemImage: "film")
                        }
                    
                    Text("Other marvel (assembled, legends etc.)")
                        .tabItem {
                            Label("Marvel other", systemImage: "film")
                        }
                }
                
                if UserDefaultsService.standard.showActorsAndDirectors {
                    DirectorListPageView(showLoader: $showLoader)
                        .tabItem {
                            Label("Directors", systemImage: "person.fill")
                        }
                    
                    ActorListPageView(showLoader: $showLoader)
                        .tabItem {
                            Label("Actors", systemImage: "person.fill")
                        }
                }
                
                if UserDefaultsService.standard.showNewsTab {
                    InstagramView()
                        .tabItem {
                            Label("Latest news (twitter @themcutimes)", systemImage: "newspaper.fill")
                        }
                }
                
                WidgetSettingsView()
                    .tabItem{
                        Label("Settings", systemImage: "gearshape")
                    }.navigationTitle("Settings")
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
                            }
                        } else {
                            Text("Loading...")
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
