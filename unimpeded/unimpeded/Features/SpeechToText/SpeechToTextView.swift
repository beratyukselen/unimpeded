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
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                VStack(spacing: 8) {
                    Text("Dinliyorum")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Konuşmanızı metne çevirmek için küreye dokunun.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 220, height: 220)
                        .scaleEffect(viewModel.isRecording ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: viewModel.isRecording)
                    
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        viewModel.toggleRecording()
                    }) {
                        VoiceAssistantSphereView(
                            state: viewModel.isRecording ? .speaking : .idle,
                            audioLevel: viewModel.audioLevel,
                            agentKey: "ReflectionGuide"
                        )
                        .frame(width: 200, height: 200)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "text.quote")
                            .foregroundColor(.blue)
                        Text("Metin")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                        
                        if !viewModel.transcribedText.isEmpty && viewModel.transcribedText != "Dinliyorum..." {
                            Button(action: {
                                UIPasteboard.general.string = viewModel.transcribedText
                            }) {
                                Image(systemName: "doc.on.doc")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    Divider()
                    
                    ScrollView {
                        Text(viewModel.transcribedText)
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 5)
                            .opacity(viewModel.transcribedText.contains("Konuşmanızı") ? 0.5 : 1.0)
                    }
                    .frame(height: 150)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                
                Spacer()
                
                if let errorMessage = viewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(errorMessage)
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onDisappear { viewModel.stopRecording() }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background || newPhase == .inactive { viewModel.stopRecording() }
        }
    }
}

#Preview {
    SpeechToTextView()
}
