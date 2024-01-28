//
//  OnboardingPageThreeView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

struct OnboardingPageThreeView: View {
    @State var notificationNews: Bool
    
    let notificationService = NotificationService()
    
    init() {
        notificationNews = notificationService.isSubscribedTo(topic: Constants.newsTopic)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Notifications")
                .font(.largeTitle)
                .bold()
            
            Text("If you want to stay up to date with all the latest mcu news, you can follow the news topic below.")
            
            VStack {
                Toggle("News", isOn: $notificationNews)
                    .onChange(of: notificationNews, { _, _ in
                        toggleTopic(Constants.newsTopic)
                    })
            }
        }
    }
    
    func toggleTopic(_ topic: String) {
        notificationService.toggleTopic(topic)
    }
}
