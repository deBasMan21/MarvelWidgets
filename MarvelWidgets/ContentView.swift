//
//  ContentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State var urlClickedProject: [Int: Bool] = [:]
    @State var selectedIndex: Int = 0
    @State var shouldStopReload = false
    
    @State var showLoader = false
    
    var body: some View {
        ZStack {
            
            TabView(selection: $selectedIndex) {
                ProjectListView(activeProject: $urlClickedProject, type: .all, shouldStopReload: $shouldStopReload, showLoader: $showLoader)
                    .tabItem{
                        Label("All", systemImage: "list.dash")
                    }.tag(0)
                
                ProjectListView(activeProject: $urlClickedProject, type: .movies, shouldStopReload: $shouldStopReload, showLoader: $showLoader)
                    .tabItem{
                        Label("Movies", systemImage: "film")
                    }.tag(1)
                
                ProjectListView(activeProject: $urlClickedProject, type: .series, shouldStopReload: $shouldStopReload, showLoader: $showLoader)
                    .tabItem{
                        Label("Series", systemImage: "tv")
                    }.tag(2)
                
                ProjectListView(activeProject: $urlClickedProject, type: .saved, shouldStopReload: $shouldStopReload, showLoader: $showLoader)
                    .tabItem{
                        Label("Saved", systemImage: "bookmark.fill")
                    }.tag(3)
                
                WidgetSettingsView()
                    .tabItem{
                        Label("Instellingen", systemImage: "gearshape")
                    }.tag(4)
            }.onOpenURL(perform: { url in
                Task {
                    await MainActor.run {
                        selectedIndex = 0
                        if url.scheme == "mcuwidgets" {
                            if url.host == "project" {
                                shouldStopReload = true
                                urlClickedProject[Int(url.lastPathComponent) ?? -1] = true
                            }
                        }
                    }
                }
            }).disabled(showLoader)
            
            if showLoader {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        ProgressView()
                            .padding(10)
                            .background(.red)
                            .cornerRadius(10)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }.background(.black.opacity(0.7))
                    .transition(.opacity)
            }
        }
    }
}
