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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Öğrenme Durumum")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("%\(Int(viewModel.progress * 100))")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 10)
                                    .foregroundColor(Color.gray.opacity(0.2))
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: geometry.size.width * viewModel.progress, height: 10)
                                    .foregroundColor(.blue)
                                    .animation(.spring(), value: viewModel.progress)
                            }
                        }
                        .frame(height: 10)
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
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
                    .padding(.horizontal)
                    
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
                                    NavigationLink(destination: SignLanguageDetailView(word: item, viewModel: viewModel)) {
                                        SignWordCard(item: item, isLearned: viewModel.isLearned(item))
                                    }
                                    .buttonStyle(PlainButtonStyle())
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

struct SignWordCard: View {
    let item: SignWord
    let isLearned: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Color.blue.opacity(0.1)
                
                if Bundle.main.path(forResource: item.gifName, ofType: "gif") != nil {
                    GifImage(item.gifName)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .allowsHitTesting(false)
                } else {
                    Image(systemName: "hands.sparkles.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue.opacity(0.5))
                }
                
                if isLearned {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                        .padding(8)
                        .background(Color.white.clipShape(Circle()))
                        .padding(5)
                }
            }
            .frame(height: 140)
            .clipped()
            
            Text(item.word.capitalized)
                .font(.headline)
                .foregroundColor(isLearned ? .green : .primary)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemGroupedBackground))
        }
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    SignLanguageSearchView()
}
