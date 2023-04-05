//
//  ContentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI
import WidgetKit
import FirebaseRemoteConfig

struct ContentView: View {
    @State var showSheet: Bool = false
    @State var showLoader = false
    
    @State var showView = false
    
    @State var detailView: ProjectDetailView?
    @State var showOnboarding: Bool = {
        !UserDefaultsService.standard.seenOnboarding || UserDefaultsService.standard.alwaysShowOnboarding
    }()
    @State var remoteConfig: RemoteConfigWrapper = RemoteConfigWrapper()
    
    var body: some View {
        ZStack {
            if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .zIndex(1)
                    .onDisappear {
                        UserDefaultsService.standard.seenOnboarding = true
                    }
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
                    PersonListPageView(type: .actor, showLoader: $showLoader)
                }.tabItem {
                    Label("Actors", systemImage: "person.fill")
                }
                
                NavigationView {
                    PersonListPageView(type: .director, showLoader: $showLoader)
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
                
                // Setup fb remote config
                let settings = RemoteConfigSettings()
                settings.minimumFetchInterval = 0
                
                let remoteConfig = RemoteConfig.remoteConfig()
                remoteConfig.configSettings = settings
                remoteConfig.setDefaults(fromPlist: "remote_config_defaults")
                remoteConfig.fetchAndActivate()
                
                remoteConfig.addOnConfigUpdateListener(remoteConfigUpdateCompletion: { update, error in
                    guard update != nil, error == nil else {
                        return
                    }
                    
                    remoteConfig.activate(completion: { succes, error in
                        guard error == nil else { return }
                        self.remoteConfig.updateValues()
                    })
                })
                
                self.remoteConfig.remoteConfig = remoteConfig
            }.onOpenURL(perform: { url in
                if (url.scheme == "mcuwidgets" && url.host == "project") || url.host == "mcuwidgets.page.link", let id = Int(url.lastPathComponent) {
                    
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
                                    rating: nil,
                                    reviewTitle: nil,
                                    reviewSummary: nil,
                                    reviewCopyright: nil
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
            .environmentObject(remoteConfig)
    }
}

class RemoteConfigWrapper: ObservableObject {
    var remoteConfig: RemoteConfig? = nil {
        didSet {
            updateValues()
        }
    }
    
    @Published var showReview: Bool = false
    @Published var showShare: Bool = false
    @Published var hideTabbar: Bool = false
    
    init() {
        updateValues()
    }
    
    func updateValues() {
        Task {
            await MainActor.run {
                withAnimation {
                    self.showReview = getProperty(property: .showReview)
                    self.showShare = getProperty(property: .showShare)
                    self.hideTabbar = getProperty(property: .showTabbar)
                }
            }
        }
    }
    
    private func getProperty(property: RemoteConfigKey) -> Bool {
        guard let remoteConfig = remoteConfig else { return false }
        let res = remoteConfig.configValue(forKey: property.rawValue)
        return res.boolValue
    }
    
    private enum RemoteConfigKey: String, CaseIterable {
        case showReview = "showReview"
        case showShare = "showShare"
        case showTabbar = "hideTabbar"
    }
}
