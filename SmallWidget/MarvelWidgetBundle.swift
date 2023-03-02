//
//  WidgetBundle.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/08/2022.
//

import Foundation
import SwiftUI

@main
struct MarvelWidgetBundle: WidgetBundle {
    var body: some Widget {
        SmallWidget()
        OtherWidgets()
    }
}
