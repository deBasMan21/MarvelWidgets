//
//  AppIcon.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import UIKit

class AppIcon: Identifiable {
    let id = UUID()
    let imageName: String
    let appIconName: String?
    
    init(imageName: String, appIconName: String?) {
        self.imageName = imageName
        self.appIconName = appIconName
    }
    
    func setIconActive() {
        UIApplication.shared.setAlternateIconName(appIconName)
    }
}
