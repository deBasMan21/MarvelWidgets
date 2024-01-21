//
//  IntentHandler.swift
//  WidgetTypeConfiguration
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Intents
import WidgetKit
import UIKit

class IntentHandler: INExtension, SpecificWidgetIntentHandling {
    func provideSelectedProjectsOptionsCollection(for intent: SpecificWidgetIntent) async throws -> INObjectCollection<SelectableProject> {
       var projects = await ProjectService.getAll()
            .compactMap {
                let isMCU = $0.attributes.source == .mcu
                let proj = SelectableProject(identifier: "\(isMCU ? "mcu" : "other")-\($0.id)", display: "\($0.attributes.title)", subtitle: isMCU ? "MCU" : "Other Marvel projects", image: nil)
                proj.sortKey = "\(isMCU ? "mcu" : "other")-\($0.attributes.title)"
                return proj
            }
        
        return INObjectCollection(items: projects.sorted(by: { $0.sortKey ?? "" < $1.sortKey ?? "" }))
    }

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        return self
    }
}
