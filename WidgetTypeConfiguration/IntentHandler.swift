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
                let proj = SelectableProject(identifier: "mcu-\($0.id)", display: "\($0.attributes.title)", subtitle: "MCU", image: nil)
                proj.sortKey = "MCU-\($0.attributes.title)"
                return proj
            }
        
        projects += await ProjectService.getAll(for: .other, populate: .populateNone)
            .compactMap {
                let proj = SelectableProject(identifier: "other-\($0.id)", display: "\($0.attributes.title)", subtitle: "Related to MCU", image: nil)
                proj.sortKey = "Other-\($0.attributes.title)"
                return proj
            }
        
        projects = projects.sorted(by: { $0.sortKey ?? "" < $1.sortKey ?? "" })
        return INObjectCollection(items: projects)
    }

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        return self
    }
}
