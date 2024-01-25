//
//  TrackingService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/06/2023.
//

import Foundation
import UIKit

class TrackingService: Service {
    static func trackPage(page: TrackingPage) async {
        guard let url = URL(string: "\(config.trackingUrl)/tracking"),
              let deviceId = await UIDevice.current.identifierForVendor?.uuidString else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue(deviceId, forHTTPHeaderField: "Authentication")
        
        let jsonData = try? JSONEncoder().encode(page)
        request.httpBody = jsonData
        
        let _ = try? await URLSession.shared.data(for: request)
    }
}

struct TrackingPage: Codable {
    let pageId: String
    let pageType: String
    
    init(pageId: Int, pageType: Page) {
        self.pageId = "\(pageId)"
        self.pageType = pageType.rawValue
    }
}

enum Page: String {
    case actor = "ACTOR"
    case director = "DIRECTOR"
    case project = "PROJECT"
}
