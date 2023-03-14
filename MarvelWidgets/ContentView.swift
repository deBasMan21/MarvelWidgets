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
    @State var showOnboarding: Bool = {
        !UserDefaultsService.standard.seenOnboarding || UserDefaultsService.standard.alwaysShowOnboarding
    }()
    
    var body: some View {
        ZStack {
            if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .zIndex(1)
            }
            
            TabView {
                NavigationView {
                    ProjectListView(pageType: .mcu, showLoader: $showLoader).navigationBarState(.compact, displayMode: .automatic)
                }.tabItem{
                    Label("MCU", systemImage: "list.dash")
                }
                
                NavigationView {
                    ProjectListView(pageType: .other, showLoader: $showLoader)
                }.tabItem{
                    Label("Related", systemImage: "film")
                }
                
                NavigationView {
                    ActorListPageView(showLoader: $showLoader)
                }.tabItem {
                    Label("Actors", systemImage: "person.fill")
                }
                
                NavigationView {
                    DirectorListPageView(showLoader: $showLoader)
                }.tabItem {
                    Label("Directors", systemImage: "megaphone")
                }
                
                NavigationView {
                    WidgetSettingsView()
                }.tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            }.onAppear {
                // Fix to always show the tabbar background
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }.onOpenURL(perform: { url in
                if url.scheme == "mcuwidgets", url.host == "project", let id = Int(url.lastPathComponent) {
                        self.detailView = ProjectDetailView(
                            viewModel: ProjectDetailViewModel(
                                project: ProjectWrapper(
                                    id: id,
                                    attributes: MCUProject(
                                        title: "Loading...",
                                        releaseDate: nil,
                                        postCreditScenes: nil,
                                        duration: nil,
                                        voteCount: nil,
                                        awardsNominated: nil,
                                        awardsWon: nil,
                                        productionBudget: nil,
                                        phase: .unkown,
                                        saga: .infinitySaga,
                                        overview: nil,
                                        type: .special,
                                        boxOffice: nil,
                                        createdAt: nil,
                                        updatedAt: nil,
                                        disneyPlusUrl: nil,
                                        categories: nil,
                                        quote: nil,
                                        quoteCaption: nil,
                                        directors: nil,
                                        actors: nil,
                                        relatedProjects: nil,
                                        trailers: nil,
                                        posters: nil,
                                        seasons: nil,
                                        rating: nil
                                    )
                                )
                            ),
                            showLoader: $showLoader
                        )
                        
                        self.showSheet = true
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
                            .background(Color.accentColor)
                            .cornerRadius(10)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }.background(.black.opacity(0.7))
                    .transition(.opacity)
            }
        }.navigationBarState(.compact, displayMode: .automatic)
    }
}
