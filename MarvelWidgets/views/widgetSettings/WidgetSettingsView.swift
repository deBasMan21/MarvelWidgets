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
        NavigationView {
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
                                Text("Movie")
                            }
                            
                            Toggle(isOn: $viewModel.notificationSerie) {
                                Text("Serie")
                            }
                            
                            Toggle(isOn: $viewModel.notificationSpecial) {
                                Text("Special")
                            }
                        }
                        
                        Divider()
                        
                        VStack {
                            Text("Small widget settings")
                                .font(Font.title2.bold())
                                .foregroundColor(.accentColor)
                            
                            Toggle(isOn: $viewModel.showText, label: {
                                Text("Show text on small widget:")
                            })
                        }
                        
                        Divider()
                        
                        VStack {
                            Text("Specific widget settings")
                                .font(Font.title2.bold())
                                .foregroundColor(.accentColor)
                            
                            Text("A specific widget is a widget that only shows the movie that is selected here. This will not affect any other widget.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                            
                            Menu(content: {
                                ForEach(viewModel.projects, id: \.id){ item in
                                    Button(item.attributes.title, action: {
                                        viewModel.setSpecificProject(to: item.id, with: item.attributes.title)
                                    })
                                }
                            }, label: {
                                HStack {
                                    Text("Selected:")
                                    
                                    Spacer()
                                    
                                    Text("**\(viewModel.selectedProjectTitle ?? "None")**")
                                        .foregroundColor(.accentColor)
                                    
                                    Image(systemName: "arrow.up.arrow.down")
                                }.foregroundColor(Color(uiColor: UIColor.label))
                            })
            
                            WidgetPreviewView(project: $viewModel.selectedProjectObject)
                                .padding()
                        }
                        
                        Spacer()
                        
                        
                    }.padding()
                }
                
                Text("Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown")")
                    .padding()
            }.navigationTitle("Settings")
        }
    }
}
