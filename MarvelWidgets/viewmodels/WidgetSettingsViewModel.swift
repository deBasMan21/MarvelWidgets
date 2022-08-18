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
        @Published var showText: Bool = true {
            didSet {
                setShowText(to: showText)
            }
        }
        
        let userDefs = UserDefaults(suiteName: UserDefaultValues.suiteName)!
        
        init() {
            showText = userDefs.bool(forKey: UserDefaultValues.smallWidgetShowText)
        }
        
        func setShowText(to showText: Bool) {
            userDefs.set(showText, forKey: UserDefaultValues.smallWidgetShowText)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}


