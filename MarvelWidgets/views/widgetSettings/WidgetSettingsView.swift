//
//  WidgetSettingsView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI
import WidgetKit

struct WidgetSettingsView: View {
    @StateObject var viewModel = WidgetSettingsViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Small widget settings")
                    .font(Font.headline.bold())
                    .foregroundColor(.accentColor)
                
                Toggle(isOn: $viewModel.showText, label: {
                    Text("Show text on small widget:")
                })
                
                Spacer()
                
                Text("Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown")")
            }.navigationTitle("Settings")
                .padding()
        }
    }
}
