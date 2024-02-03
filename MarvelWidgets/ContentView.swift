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
    @State var showAlert: Bool = false
    @State var activeTab: Int = 0
    @State var showOnboarding: Bool = {
        !UserDefaultsService.standard.seenOnboarding || UserDefaultsService.standard.alwaysShowOnboarding
    }()
    
    @State var detailView: ProjectDetailView?
    @State var openUrlHelper: OpenUrlWrapper?
    
    @State var pages = NavigationPath()
    @State var news = NavigationPath()
    @State var projects = NavigationPath()
    @State var persons = NavigationPath()
    
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
                NavigationStack(path: $pages) {
                    HomePageView()
                        .addAllNavigationDestinations()
                }.tabItem {
                    Label("Homepage", systemImage: "house.fill")
                }.tag(0)
                
                NavigationStack(path: $news) {
                    NewsListPageView()
                        .addAllNavigationDestinations()
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
                        .addAllNavigationDestinations()
                }.tabItem{
                    Label("Projects", systemImage: "film")
                }.tag(3)
                
                NavigationStack(path: $persons) {
                    PersonListPageView()
                        .addAllNavigationDestinations()
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
                        _ = handleUrl(url: openUrlHelper?.lastUrl)
                    }
                })
            }.onOpenURL(perform: { url in
                _ = handleUrl(url: url)
            })
        }.navigationBarState(.compact, displayMode: .automatic)
            .toast(isPresenting: $showAlert, duration: 10, tapToDismiss: true, alert: {
                AlertToast(displayMode: .hud, type: .systemImage("bell", .accentColor), title: openUrlHelper?.lastTitle ?? "", subTitle: openUrlHelper?.lastBody)
            }, onTap: {
                _ = handleUrl(url: openUrlHelper?.lastUrl)
            }).preferredColorScheme(.dark)
            .onOpenUrlAction { url in
                handleUrl(url: url)
            }
    }
    
    func handleUrl(url: URL?) -> Bool {
        guard let url else { return false }
        
        if url.host == "mcuwidgets.page.link" {
            guard let id = Int(url.lastPathComponent) else { return false }
            guard url.pathComponents.count > 1 else { return false }
            
            var activeTab = 0
            var item: any Hashable = ""
            var isHomePage = false
            
            var pathComponent = url.pathComponents[1]
            if pathComponent == "home" {
                isHomePage = true
                pathComponent = url.pathComponents[2]
            }
            
            switch pathComponent {
            case "project":
                activeTab = 3
                item = Placeholders.loadingProject(id: id)
                
            case "actor":
                activeTab = 4
                item = Placeholders.loadingActor(id: id)
                
            case "director":
                activeTab = 4
                item = Placeholders.loadingDirector(id: id)
                
            case "page":
                activeTab = 0
                item = Placeholders.loadingPage(id: id)
                
            case "news":
                activeTab = 1
                item = Placeholders.loadingNews(id: id)
                
            case "collection":
                activeTab = 3
                item = Placeholders.loadingCollection(id: id)

            default: return false
            }
            
            if isHomePage {
                activeTab = 0
            }
            
            self.activeTab = activeTab
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                switch activeTab {
                case 0: pages.append(item)
                case 1: news.append(item)
                case 3: projects.append(item)
                case 4: persons.append(item)
                default: break
                }
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
    var lastUrl: URL?
    
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
            url.host == "mcuwidgets.page.link" {
            
            self.lastTitle = title
            self.lastBody = body
            self.lastUrl = url
            
            callback(inApp)
        }
    }
}

struct OpenURLHandlerAction {
    typealias Action = (URL?) -> Bool
    let action: Action
    func callAsFunction(_ url: URL?) -> Bool {
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
    
    func addAllNavigationDestinations() -> some View {
        self
            .navigationDestination(for: CustomPageWrapper.self) { i in
                CustomPageView(pageId: i.id)
            }
            .navigationDestination(for: NewsItemWrapper.self) { i in
                NewsItemDetailView(newsItem: i)
            }
            .navigationDestination(for: ProjectWrapper.self) { i in
                ProjectDetailView(
                    viewModel: ProjectDetailViewModel(
                        project: i
                    ),
                    inSheet: false
                )
            }
            .navigationDestination(for: ActorsWrapper.self) { i in
                PersonDetailView(person: i.person)
            }.navigationDestination(for: DirectorsWrapper.self) { i in
                PersonDetailView(person: i.person)
            }.navigationDestination(for: ProjectCollection.self) { i in
                CollectionPageView(collection: i, inSheet: false)
            }
    }
}
