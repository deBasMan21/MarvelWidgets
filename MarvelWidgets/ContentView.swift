//
//  ContentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI
import WidgetKit
import FirebaseRemoteConfig
import AlertToast

struct ContentView: View {
    @State var showView = false
    @State var projects = NavigationPath()
    
    @State var detailView: ProjectDetailView?
    @State var showOnboarding: Bool = {
        !UserDefaultsService.standard.seenOnboarding || UserDefaultsService.standard.alwaysShowOnboarding
    }()
    @State var remoteConfig: RemoteConfigWrapper = RemoteConfigWrapper()
    
    @State var openUrlHelper: OpenUrlWrapper?
    
    @State var showAlert: Bool = false
    @State var activeTab: Int = 0
    
    var body: some View {
        ZStack {
            if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .zIndex(1)
                    .onDisappear {
                        UserDefaultsService.standard.seenOnboarding = true
                    }
            }
            
            TabView(selection: $activeTab) {
                NavigationStack(path: $projects) {
                    ProjectListView(pageType: .mcu)
                        .navigationDestination(for: ProjectWrapper.self) { i in
                            ProjectDetailView(viewModel: ProjectDetailViewModel(project: i),  inSheet: false)
                        }
                }.tabItem{
                    Label("MCU", systemImage: "list.dash")
                }.tag(0)
                
                NavigationView {
                    ProjectListView(pageType: .other)
                }.tabItem{
                    Label("Related", systemImage: "film")
                }.tag(1)
                
                NavigationView {
                    PersonListPageView(type: .actor)
                }.tabItem {
                    Label("Actors", systemImage: "person.fill")
                }.tag(2)
                
                NavigationView {
                    PersonListPageView(type: .director)
                }.tabItem {
                    Label("Directors", systemImage: "megaphone")
                }.tag(3)
                
                NavigationView {
//                    WidgetSettingsView()
                    SwipingParentView(activeTab: $activeTab)
                }.tabItem {
                    Label("Settings", systemImage: "gearshape")
                }.tag(4)
            }.onAppear {
                // Fix to always show the tabbar background
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                
                openUrlHelper = OpenUrlWrapper(callback: { inApp in
                    if inApp {
                        showAlert = true
                    } else {
                        self.projects.append(openUrlHelper?.lastProject)
                    }
                })
                
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
                if (url.scheme == "mcuwidgets" && url.host == "project") || url.host == "mcuwidgets.page.link",
                   let id = Int(url.lastPathComponent) {
                    projects.append(Placeholders.loadingProject(id: id, type: url.pathComponents[1] == "other" ? .sony : .special))
                }
            })
        }.navigationBarState(.compact, displayMode: .automatic)
            .environmentObject(remoteConfig)
            .toast(isPresenting: $showAlert, duration: 10, tapToDismiss: true, alert: {
                AlertToast(displayMode: .hud, type: .systemImage("bell", .accentColor), title: openUrlHelper?.lastTitle ?? "", subTitle: openUrlHelper?.lastBody)
            }, onTap: {
                if let project = openUrlHelper?.lastProject {
                    projects.append(project)
                }
            })
    }
}

class OpenUrlWrapper {
    let callback: (Bool) -> Void
    var lastTitle: String = ""
    var lastBody: String?
    var lastProject: ProjectWrapper?
    
    init(callback: @escaping (Bool) -> Void) {
        self.callback = callback
        setupNotificationListener()
    }
    
    func setupNotificationListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(openUrl(notification:)), name: Notification.Name(rawValue: "url"), object: nil)
    }
    
    @objc func openUrl(notification: NSNotification) {
        let url = notification.userInfo?["url"] as? String
        let inApp = notification.userInfo?["inApp"] as? Bool
        let title = notification.userInfo?["title"] as? String
        let body = notification.userInfo?["body"] as? String
        
        if let url = url,
            let url = URL(string: url),
            let inApp = inApp,
            let title = title,
            let id = Int(url.lastPathComponent),
            ((url.scheme == "mcuwidgets" && url.host == "project") || url.host == "mcuwidgets.page.link") {
            
            self.lastTitle = title
            self.lastBody = body
            self.lastProject = Placeholders.loadingProject(id: id, type: url.pathComponents[1] == "other" ? .sony : .special)
            
            callback(inApp)
        }
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
