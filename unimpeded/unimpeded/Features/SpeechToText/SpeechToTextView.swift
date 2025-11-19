//
//  SpeechToTextView.swift
//  unimpeded
//
//  Created by Berat Yükselen on 17.11.2025.
//

import SwiftUI

struct SpeechToTextView: View {
    
    @StateObject private var viewModel = SpeechToTextViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text(viewModel.transcribedText)
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 150)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Spacer()

            Button(action: {
                viewModel.toggleRecording()
            }) {
                Image(systemName: viewModel.isRecording ? "mic.fill" : "mic.slash.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(20)
                    .background(viewModel.isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            .padding(.bottom, 80)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    SpeechToTextView()
}
