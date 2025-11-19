//
//  MainTabView.swift
//  unimpeded
//
//  Created by Berat Yükselen on 19.11.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        // TabView, ekranlar arasında geçişi sağlar
        TabView {
            
            // Sekme 1: Konuşmadan Metne (SST)
            SpeechToTextView()
                .tabItem {
                    Label("Konuşma", systemImage: "mic.fill")
                }
            
            // Sekme 2: Metinden Sese (TTS)
            TextToSpeechView()
                .tabItem {
                    Label("Yaz & Seslendir", systemImage: "speaker.wave.2.fill")
                }
            
            // Sekme 3: İşaret Dili Arama
            SignLanguageSearchView()
                .tabItem {
                    Label("İşaret Dili", systemImage: "hand.raised.fill")
                }
        }
        // Temiz bir kullanıcı deneyimi için mavi tint rengi kullanalım
        .tint(.blue)
    }
}

#Preview {
    MainTabView()
}
