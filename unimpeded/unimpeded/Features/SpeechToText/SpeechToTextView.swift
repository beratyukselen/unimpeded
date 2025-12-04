//
//  SpeechToTextView.swift
//  unimpeded
//
//  Created by Berat Yükselen on 17.11.2025.
//

import SwiftUI
import Lottie

struct SpeechToTextView: View {
    
    @StateObject private var viewModel = SpeechToTextViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Konuşmanızı Metne Çevir")
                .font(.headline)
                .padding(.top, 20)
            
            Spacer()

            // Metin Alanı
            Text(viewModel.transcribedText)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 150)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
            
            Spacer()

            // MARK: - Voice Assistant Sphere
            // Butonun kendisi
            Button(action: {
                viewModel.toggleRecording()
            }) {
                VoiceAssistantSphereView(
                    state: viewModel.isRecording ? .speaking : .idle,
                    audioLevel: viewModel.audioLevel, // Artık güçlendirilmiş ses verisi gidiyor
                    agentKey: "ReflectionGuide"
                )
                // Kürenin boyutu BURADAN kontrol ediliyor
                .frame(width: 180, height: 180)
            }
            .buttonStyle(PlainButtonStyle()) // Butonun varsayılan basma efektini kaldırır
            .padding(.bottom, 50)

            // Hata Mesajı
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.bottom, 10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    SpeechToTextView()
}
