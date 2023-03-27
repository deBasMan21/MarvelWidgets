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
    @StateObject var webView = WebViewModel()
    
    var body: some View {
        VStack {
            WebView(webView: webView.webView)
        }.navigationTitle("Latest news")
    }
}


class WebViewModel: ObservableObject {
    let webView: WKWebView
    let url: URL
    
    init() {
        webView = WKWebView(frame: .zero)
        
        url = URL(string: "https://twitter.com/themcutimes")!

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
