//
//  InstagramView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 20/11/2022.
//

import Foundation
import SwiftUI
import WebKit

struct InstagramView: View {
    @StateObject var webView = WebViewModel(url: "https://twitter.com/themcutimes")
    
    var body: some View {
        VStack {
            WebView(webView: webView.webView)
        }.navigationTitle("Latest news")
    }
}


class WebViewModel: ObservableObject {
    let webView: WKWebView
    let url: URL
    
    init(url: String) {
        webView = WKWebView(frame: .zero)
        
        self.url = URL(string: url)!

        loadUrl()
    }
    
    func loadUrl() {
        webView.load(URLRequest(url: url))
    }
}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    let webView: WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
}
