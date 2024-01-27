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
                        
                        Toggle(isOn: $viewModel.notificationMovie) {
                            Text("Marvel Movies")
                        }.tint(.accentColor)
                        
                        Toggle(isOn: $viewModel.notificationSerie) {
                            Text("Marvel Series")
                        }.tint(.accentColor)
                        
                        Toggle(isOn: $viewModel.notificationSpecial) {
                            Text("Marvel Specials")
                        }.tint(.accentColor)
                        
                        Toggle(isOn: $viewModel.notificationRelated) {
                            Text("Related projects (not MCU)")
                        }.tint(.accentColor)
                        
                        #if DEBUG
                            Toggle(isOn: $viewModel.notificationTesting) {
                                Text("Testing")
                            }.tint(.accentColor)
                        #endif
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("App icon")
                            .font(.title2)
                            .bold()
                        
                        AppIconSelectView()
                    }
                    
                    Divider()
                    
                    Text("Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown")")
                    
                    #if DEBUG
                        Divider()
                        
                        Button(action: {
                            WidgetCenter.shared.reloadAllTimelines()
                        }, label: {
                            Text("Reload widgets")
                        })
                    #endif
                }.padding(.horizontal, 20)
            }
        }.navigationTitle("Settings")
            .hiddenTabBar()
    }
}
