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
    @EnvironmentObject var remoteConfig: RemoteConfigWrapper
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack {
                        VStack {
                            Text("Notification settings")
                                .font(Font.title2.bold())
                                .foregroundColor(.accentColor)
                            
                            Text("If you enable the notifications for a type of project you get a notification when a project of that type is released.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                        }
                        
                        Toggle(isOn: $viewModel.notificationMovie) {
                            Text("Marvel Movies")
                        }
                        
                        Toggle(isOn: $viewModel.notificationSerie) {
                            Text("Marvel Series")
                        }
                        
                        Toggle(isOn: $viewModel.notificationSpecial) {
                            Text("Marvel Specials")
                        }
                        
                        Toggle(isOn: $viewModel.notificationRelated) {
                            Text("Related projects (not MCU)")
                        }
                        
                        #if DEBUG
                            Toggle(isOn: $viewModel.notificationTesting) {
                                Text("Testing")
                            }
                        #endif
                    }
                    
                    #if DEBUG
                        Divider()
                        
                        Button(action: {
                            WidgetCenter.shared.reloadAllTimelines()
                        }, label: {
                            Text("Reload widgets")
                        })
                    #endif
                    
                    Spacer()
                }.padding()
            }
            
            Text("Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown")")
                .padding()
        }.navigationTitle("Settings")
            .showTabBar(featureFlag: remoteConfig.hideTabbar)
    }
}
