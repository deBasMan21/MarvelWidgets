//
//  WidgetSettingsViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation
import WidgetKit

extension WidgetSettingsView {
    class WidgetSettingsViewModel: ObservableObject {
        @Published var currentWidgetType: String = UserDefaultValues.defaultWidgetType
        let userDefs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
        
        init() {
            currentWidgetType = userDefs.string(forKey: UserDefaultValues.widgetType) ?? UserDefaultValues.defaultWidgetType
        }
        
        func setWidgetType(to type: WidgetType) {
            userDefs.set(type.rawValue, forKey: UserDefaultValues.widgetType)
            currentWidgetType = type.rawValue
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}


