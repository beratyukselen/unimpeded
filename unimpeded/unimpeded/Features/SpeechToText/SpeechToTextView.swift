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
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Konuşmanı Metne Çevir")
                .font(.headline)
                .padding(.top, 20)
            
            Spacer()

            Text(viewModel.transcribedText)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 150)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
            
            Spacer()

            Button(action: {
                viewModel.toggleRecording()
            }) {
                VoiceAssistantSphereView(
                    state: viewModel.isRecording ? .speaking : .idle,
                    audioLevel: viewModel.audioLevel,
                    agentKey: "ReflectionGuide"
                )
                .frame(width: 180, height: 180)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 50)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.bottom, 10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .onDisappear {
            viewModel.stopRecording()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background || newPhase == .inactive {
                viewModel.stopRecording()
            }
        }
    }
}
