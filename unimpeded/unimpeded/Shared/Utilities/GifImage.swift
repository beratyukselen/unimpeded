//
//  GifImage.swift
//  unimpeded
//
//  Created by Berat Yükselen on 22.12.2025.
//

import SwiftUI
import WebKit

struct GifImage: UIViewRepresentable {
    let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false

        if let url = Bundle.main.url(forResource: name, withExtension: "gif") {
            let html = """
            <!DOCTYPE html>
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                html, body {
                    margin: 0;
                    padding: 0;
                    width: 100%;
                    height: 100%;
                    background: transparent;
                    overflow: hidden;
                }
                img {
                    width: 100%;
                    height: 100%;
                    object-fit: contain;
                }
            </style>
            </head>
            <body>
                <img src="\(url.lastPathComponent)">
            </body>
            </html>
            """

            webView.loadHTMLString(html, baseURL: url.deletingLastPathComponent())
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
