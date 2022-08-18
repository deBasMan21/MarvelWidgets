//
//  WidgetSettingsView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import SwiftUI
import WidgetKit
import Kingfisher

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
                
//                Spacer()
//
//                VStack {
//                    let movie = SaveService.getProjectsFromUserDefaults()[2]
//                    SmallWidgetUpcomingSmall(upcomingProject: movie, image: ImageHelper.downloadImage(from: movie.coverURL))
//                        .frame(width: 150, height: 150)
//                        .background(.white)
//                        .cornerRadius(20)
//                }.shadow(color: .white, radius: 20, x: 0, y: 0)
                
                Spacer()
                
                Text("Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown")")
            }.navigationTitle("Settings")
                .padding()
        }
    }
}
