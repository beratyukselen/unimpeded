//
//  TextToSpeechView.swift
//  unimpeded
//
//  Created by Berat Yükselen on 19.11.2025.
//

import SwiftUI

struct TextToSpeechView: View {
    
    @StateObject private var viewModel = TextToSpeechViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
       
                VStack(spacing: 5) {
                    Text("Seslendir")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    Text("Metninizi yazın, biz okuyalım.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 30)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Image(systemName: "keyboard")
                            .foregroundColor(.purple)
                        Text("Metin Girişi")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                        
                        Text("\(viewModel.textToSpeak.count) karakter")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    
                    Divider()
                    
                    ZStack(alignment: .topLeading) {
                        if viewModel.textToSpeak.isEmpty {
                            Text("Buraya yazmaya başlayın...")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.top, 12)
                                .padding(.leading, 16)
                        }
                        
                        TextEditor(text: $viewModel.textToSpeak)
                            .focused($isFocused)
                            .scrollContentBackground(.hidden)
                            .padding(10)
                            .frame(height: 200)
                    }
                    .background(Color(.secondarySystemGroupedBackground))
                }
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                
                HStack(spacing: 20) {
                    Button(action: {
                        withAnimation { viewModel.clearText() }
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }) {
                        VStack {
                            Image(systemName: "trash")
                                .font(.system(size: 20))
                            Text("Temizle")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.red.opacity(0.8))
                        .frame(width: 80, height: 80)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                    
                    Button(action: {
                        viewModel.speak()
                        isFocused = false
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "waveform")
                                .font(.title2)
                            Text("Seslendir")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(20)
                        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .onTapGesture {
                isFocused = false
            }
        }
    }
}

#Preview {
    TextToSpeechView()
}
