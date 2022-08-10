//
//  IntentHandler.swift
//  WidgetTypeConfiguration
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        return self
    }
    
}
