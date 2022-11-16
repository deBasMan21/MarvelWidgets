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
                    VStack(spacing: 50) {
                        VStack {
                            Text("Small widget settings")
                                .font(Font.title2.bold())
                                .foregroundColor(.accentColor)
                            
                            Toggle(isOn: $viewModel.showText, label: {
                                Text("Show text on small widget:")
                            })
                        }
                        
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
                
                Button("Subscribe to all", action: {
                    Messaging.messaging().subscribe(toTopic: "Movie") { error in
                        print("subscirbed to Movies")
                    }
                    Messaging.messaging().subscribe(toTopic: "Serie") { error in
                        print("subscirbed to Series")
                    }
                    Messaging.messaging().subscribe(toTopic: "Special") { error in
                        print("subscirbed to Specials")
                    }
                })
            }.navigationTitle("Settings")
        }
    }
}
