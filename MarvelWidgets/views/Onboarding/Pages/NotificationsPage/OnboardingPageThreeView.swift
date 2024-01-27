//
//  OnboardingPageThreeView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

struct OnboardingPageThreeView: View {
    @State var notificationMovie: Bool
    @State var notificationSerie: Bool
    @State var notificationSpecial: Bool
    
    let notificationService = NotificationService()
    
    init() {
        notificationMovie = notificationService.isSubscribedTo(topic: .movie)
        notificationSerie = notificationService.isSubscribedTo(topic: .serie)
        notificationSpecial = notificationService.isSubscribedTo(topic: .special)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Notifications")
                .font(.largeTitle)
                .bold()
            
            Text("For these types projects you can receive notifications about updates and releases.")
            
            VStack {
                Toggle("Movies", isOn: $notificationMovie)
                    .onChange(of: notificationMovie, perform: { _ in
                        toggleTopic(.movie)
                    })
                
                Toggle("Series", isOn: $notificationSerie)
                    .onChange(of: notificationSerie, perform: { _ in
                        toggleTopic(.serie)
                    })
                
                Toggle("Specials", isOn: $notificationSpecial)
                    .onChange(of: notificationSpecial, perform: { _ in
                        toggleTopic(.special)
                    })
            }
        }
    }
    
    func toggleTopic(_ topic: NotificationTopics) {
        notificationService.toggleTopic(topic)
    }
}
