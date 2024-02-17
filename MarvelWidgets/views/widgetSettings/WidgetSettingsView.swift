//
//  WidgetSettingsView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI
import WidgetKit
import Kingfisher
import FirebaseMessaging

struct WidgetSettingsView: View {
    @StateObject var viewModel = WidgetSettingsViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack {
                        Text("Notifications")
                            .font(.title2)
                            .bold()
                        
                        Toggle(isOn: $viewModel.notificationNews) {
                            Text("News")
                        }.tint(.accentColor)
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("App icon")
                            .font(.title2)
                            .bold()
                        
                        AppIconSelectView()
                    }
                    
                    Divider()
                    
                    VStack(spacing: 15) {
                        Text("Credits")
                            .font(.title2)
                            .bold()
                        
                        CompanyCopyrightView(
                            imageName: "tmdbLogo",
                            text: "This app uses TMDB and the TMDB APIs but is not endorsed, certified, or otherwise approved by TMDB."
                        )
                        
                        CompanyCopyrightView(
                            imageName: "nytBigLogo",
                            text: "This app uses the New York Times API to gather movie reviews. All reviews fall under copyright of NYT and in no case are presented as own content."
                        )
                        
                        CompanyCopyrightView(
                            imageName: "theDirectLogo",
                            text: "This app uses a RSS feed from The Direct for the latest news. All rights for news articles in this app belong to The Direct."
                        )
                    }
                    
                    Divider()
                    
                    Text("Version: ") +
                    Text("\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown")").bold()
                    
                    #if DEBUG
                    Divider()
                    
                    Button(action: {
                        WidgetCenter.shared.reloadAllTimelines()
                    }, label: {
                        Text("Reload widgets")
                    })
                    
                    Button(action: {
                        print("debug: \(Messaging.messaging().fcmToken ?? "unkown")")
                        UIPasteboard.general.string = Messaging.messaging().fcmToken
                    }) {
                        Text("Copy fcm token")
                    }
                    #endif
                }.padding(.horizontal, 20)
            }
        }.navigationTitle("Settings")
            .hiddenTabBar()
    }
}
