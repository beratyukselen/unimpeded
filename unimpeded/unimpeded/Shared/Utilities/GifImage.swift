//
//  GifImage.swift
//  unimpeded
//
//  Created by Berat Yükselen on 22.12.2025.
//

import SwiftUI
import WebKit

struct GifImage: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        
        if let url = Bundle.main.url(forResource: name, withExtension: "gif") {
            do {
                let data = try Data(contentsOf: url)
                webView.load(
                    data,
                    mimeType: "image/gif",
                    characterEncodingName: "UTF-8",
                    baseURL: url.deletingLastPathComponent()
                )
            } catch {
                print("GIF yüklenemedi: \(error.localizedDescription)")
            }
        } else {
             print("GIF dosyası bulunamadı: \(name).gif")
        }
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
