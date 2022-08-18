//
//  VideoView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import WebKit
import SwiftUI

struct VideoView: UIViewRepresentable{

    let videoURL: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context){
        var url: URL
        if videoURL.starts(with: "https://youtu") {
            guard let tempUrl = URL(string: videoURL) else { return }
            let videoId = tempUrl.lastPathComponent
            guard let embedUrl = URL(string: "https://youtube.com/embed/\(videoId)") else { return }
            url = embedUrl
        } else {
            guard let tempUrl = URL(string: videoURL) else { return }
            url = tempUrl
        }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: url))
    }
}
