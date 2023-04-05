//
//  IntentHandler.swift
//  WidgetTypeConfiguration
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Intents
import WidgetKit

class IntentHandler: INExtension, SpecificWidgetIntentHandling {
    func provideSelectedProjectsOptionsCollection(for intent: SpecificWidgetIntent) async throws -> INObjectCollection<SelectableProject> {
        var projects = await ProjectService.getAll(populate: .populateNone)
            .compactMap { SelectableProject(identifier: "mcu-\($0.id)", display: "MCU - \($0.attributes.title)") }
        
        let otherProjects = await ProjectService.getAllOther(populate: .populateNone)
            .compactMap { SelectableProject(identifier: "other-\($0.id)", display: "Other - \($0.attributes.title)")}
        
        projects.append(contentsOf: otherProjects)
        
        projects = projects.sorted(by: {
            $0.displayString < $1.displayString
        })
        return INObjectCollection(items: projects)
    }

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        return self
    }
}
