//
//  SignLanguageDetailView.swift
//  unimpeded
//
//  Created by Berat Yükselen on 22.12.2025.
//

import SwiftUI

struct SignLanguageDetailView: View {
    
    let word: SignWord
    @ObservedObject var viewModel: SignLanguageSearchViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Text(word.word.capitalized)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .padding(.top, 20)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    if Bundle.main.path(forResource: word.gifName, ofType: "gif") != nil {
                        GifImage(word.gifName)
                            .scaledToFit()
                            .cornerRadius(20)
                    } else {
                        Image(systemName: "hands.sparkles.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue.opacity(0.3))
                    }
                }
                .frame(height: 300)
                .padding(.horizontal)
                
                if viewModel.isLearned(word) {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                        Text("Bu kelimeyi öğrendin!")
                    }
                    .foregroundColor(.green)
                    .font(.headline)
                    .padding(.top, 10)
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        viewModel.markAsUnlearned(word)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        VStack {
                            Image(systemName: "book.fill")
                                .font(.title2)
                            Text("Öğreneceğim")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(.secondarySystemGroupedBackground))
                        .foregroundColor(.primary)
                        .cornerRadius(16)
                        .shadow(radius: 2)
                    }
                    
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .heavy)
                        impact.impactOccurred()
                        viewModel.markAsLearned(word)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        VStack {
                            Image(systemName: "checkmark")
                                .font(.title2)
                            Text("Biliyorum")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: Color.green.opacity(0.4), radius: 5, x: 0, y: 5)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
