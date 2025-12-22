//
//  MainTabView.swift
//  unimpeded
//
//  Created by Berat Yükselen on 19.11.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            SpeechToTextView()
                .tabItem {
                    Label("Konuşma", systemImage: "mic.fill")
                }
            
            TextToSpeechView()
                .tabItem {
                    Label("Yaz & Seslendir", systemImage: "speaker.wave.2.fill")
                }
            
            SignLanguageSearchView()
                .tabItem {
                    Label("İşaret Dili", systemImage: "hand.raised.fill")
                }
        }
        .tint(.blue)
    }
}

#Preview {
    MainTabView()
}
