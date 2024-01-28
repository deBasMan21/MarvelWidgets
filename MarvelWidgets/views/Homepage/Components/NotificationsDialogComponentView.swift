//
//  NotificationsDialogComponentView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 25/01/2024.
//

import Foundation
import SwiftUI

struct NotificationsDialogComponentView: View {
    @State var component: NotificationsDialogComponent
    @State var subscribedTopics: [String: Bool] = [:]
    
    var body: some View {
        VStack {
            Text(component.title)
                .font(.title2)
            
            Text(component.description)
                .foregroundColor(Color(uiColor: .lightGray))
                .multilineTextAlignment(.center)
            
            VStack {
                ForEach(component.topics, id: \.topic.hashValue) { topic in
                    Toggle(isOn: binding(for: topic.topic)) {
                        Text(topic.topic.replacingOccurrences(of: "_", with: " "))
                    }.tint(.accentColor)
                    
                    if topic.id != component.topics.last?.id {
                        Divider()
                    }
                }
            }
        }.onAppear {
            setupSubscribedTopics()
        }
    }
    
    private func binding(for key: String) -> Binding<Bool> {
        return .init(
            get: { self.subscribedTopics[key, default: false] },
            set: {
                NotificationService().toggleTopic(key)
                self.subscribedTopics[key] = $0
            }
        )
    }
    
    func setupSubscribedTopics() {
        let service = NotificationService()
        subscribedTopics = component.topics.reduce(into: [String: Bool](), { acc, value in
            acc[value.topic] = service.isSubscribedTo(topic: value.topic)
        })
    }
}

