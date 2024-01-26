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
    @State var showAlert: Bool = false
    @State var activeTab: Int = 0
    @State var showOnboarding: Bool = {
        !UserDefaultsService.standard.seenOnboarding || UserDefaultsService.standard.alwaysShowOnboarding
    }()
    
    @State var detailView: ProjectDetailView?
    @State var openUrlHelper: OpenUrlWrapper?
    
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
                NavigationView {
                    HomePageView()
                }.tabItem {
                    Label("Homepage", systemImage: "house.fill")
                }.tag(0)
                
                NavigationView {
                    NewsListPageView()
                }.tabItem {
                    Label("News", systemImage: "newspaper.fill")
                }.tag(1)
                
                NavigationView {
                    SwipingParentView(activeTab: $activeTab)
                }.tabItem {
                    Label("Discover", systemImage: "star.fill")
                }.tag(2)
                
                NavigationStack(path: $projects) {
                    ProjectListView()
                        .navigationDestination(for: ProjectWrapper.self) { i in
                            ProjectDetailView(viewModel: ProjectDetailViewModel(project: i),  inSheet: false)
                        }
                }.tabItem{
                    Label("Projects", systemImage: "film")
                }.tag(3)
                
                NavigationView {
                    PersonListPageView()
                }.tabItem {
                    Label("Persons", systemImage: "person.fill")
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
            }.onOpenURL(perform: { url in
                _ = handleUrl(url: url)
            })
        }.navigationBarState(.compact, displayMode: .automatic)
            .toast(isPresenting: $showAlert, duration: 10, tapToDismiss: true, alert: {
                AlertToast(displayMode: .hud, type: .systemImage("bell", .accentColor), title: openUrlHelper?.lastTitle ?? "", subTitle: openUrlHelper?.lastBody)
            }, onTap: {
                if let project = openUrlHelper?.lastProject {
                    activeTab = 3
                    projects.append(project)
                }
            }).preferredColorScheme(.dark)
            .onOpenUrlAction { url in
                handleUrl(url: url)
            }
    }
    
    func handleUrl(url: URL) -> Bool {
        if (url.scheme == "mcuwidgets" && url.host == "project") || url.host == "mcuwidgets.page.link",
           let id = Int(url.lastPathComponent) {
            activeTab = 3
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.projects.append(Placeholders.loadingProject(id: id))
            }
            return true
        }
        return false
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
            self.lastProject = Placeholders.loadingProject(id: id)
            
            callback(inApp)
        }
    }
}

struct OpenURLHandlerAction {
    typealias Action = (URL) -> Bool
    let action: Action
    func callAsFunction(_ url: URL) -> Bool {
        action(url)
    }
}

struct OpenURLActionKey: EnvironmentKey {
    static var defaultValue: OpenURLHandlerAction? = nil
}

extension EnvironmentValues {
    var openURLHandlerAction: OpenURLHandlerAction? {
        get { self[OpenURLActionKey.self] }
        set { self[OpenURLActionKey.self] = newValue }
    }
}

extension View {
    func onOpenUrlAction(_ action: @escaping OpenURLHandlerAction.Action) -> some View {
        self.environment(\.openURLHandlerAction, OpenURLHandlerAction(action: action))
    }
}
