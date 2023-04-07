//
//  UpcomingProjectEntry.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 25/02/2023.
//

import WidgetKit
import SwiftUI
import Intents

struct UpcomingProjectEntry: TimelineEntry {
    let date: Date
    let configuration: UpcomingWidgetIntent
    let upcomingProject: ProjectWrapper?
    let image: Image
}
