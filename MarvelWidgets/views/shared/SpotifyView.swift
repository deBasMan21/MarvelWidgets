//
//  SpotifyView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 17/07/2023.
//

import WebKit
import SwiftUI

struct SpotifyView: UIViewRepresentable {

    let embedUrl: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context){
        uiView.scrollView.isScrollEnabled = false
        uiView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        uiView.configuration.allowsInlineMediaPlayback = true
        uiView.isOpaque = false
        
        guard let embedUrl = URL(string: embedUrl) else { return }
        uiView.load(URLRequest(url: embedUrl))
    }
}
