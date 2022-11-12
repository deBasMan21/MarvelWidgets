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
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            ProjectListView(activeProject: $urlClickedProject, type: .all, shouldStopReload: $shouldStopReload)
                .tabItem{
                    Label("All", systemImage: "list.dash")
                }.tag(0)
            
            ProjectListView(activeProject: $urlClickedProject, type: .movies, shouldStopReload: $shouldStopReload)
                .tabItem{
                    Label("Movies", systemImage: "film")
                }.tag(1)
            
            ProjectListView(activeProject: $urlClickedProject, type: .series, shouldStopReload: $shouldStopReload)
                .tabItem{
                    Label("Series", systemImage: "tv")
                }.tag(2)
            
            ProjectListView(activeProject: $urlClickedProject, type: .saved, shouldStopReload: $shouldStopReload)
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
        })
    }
}
