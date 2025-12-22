//
//  SignLanguageSearchView.swift
//  unimpeded
//
//  Created by Berat Yükselen on 5.12.2025.
//

import SwiftUI

struct SignLanguageSearchView: View {
    
    @StateObject private var viewModel = SignLanguageSearchViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Kelime ara (Örn: Merhaba)", text: $viewModel.searchText)
                            .foregroundColor(.primary)
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    if viewModel.searchResults.isEmpty {
                        Spacer()
                        VStack(spacing: 15) {
                            Image(systemName: "magnifyingglass.circle")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("Sonuç bulunamadı.")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(viewModel.searchResults) { item in
                                    SignWordCard(item: item)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("İşaret Dili Sözlüğü")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Yardımcı Kart Tasarımı (Alt Bileşen)
struct SignWordCard: View {
    let item: SignWord
    
    var body: some View {
        VStack(spacing: 0) { // Aradaki boşluğu sıfırladık
            // GIF veya Görsel Alanı
            ZStack {
                Color.blue.opacity(0.1) // Arka plan rengi
                
                // Dosya sisteminde bu isimde bir .gif var mı kontrol et
                if Bundle.main.path(forResource: item.gifName, ofType: "gif") != nil {
                    // Varsa GIF oynatıcıyı kullan
                    GifImage(item.gifName)
                        .scaledToFit()
                        // Web görünümü olduğu için tıklamaları engelle
                        .allowsHitTesting(false)
                } else {
                    // Yoksa placeholder göster
                    Image(systemName: "hands.sparkles.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue.opacity(0.5))
                }
            }
            .frame(height: 140) // Yüksekliği biraz artırdık
            .clipped() // Dışarı taşan kısımları kırp
            
            // Kelime Adı
            Text(item.word.capitalized)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemGroupedBackground))
        }
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}
