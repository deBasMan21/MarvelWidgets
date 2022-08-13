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
        VStack{
            Menu(content: {
                ForEach(WidgetType.allCases, id: \.self){ item in
                    Button(item.rawValue, action: {
                        viewModel.setWidgetType(to: item)
                    })
                }
            }, label: {
                Text("Geselecteerde modus: \(viewModel.currentWidgetType)")
                Image(systemName: "arrow.up.arrow.down")
            })
        }.onAppear {
            print(UserDefaults(suiteName: "savedProjects")?.array(forKey: "savedProjectIds"))
        }
    }
}
