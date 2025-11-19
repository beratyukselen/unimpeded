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
         VStack(spacing: 20) {
             
             Text("Metinden Sese")
                 .font(.headline)
                 .padding(.top)
             
             Spacer()
             
             ZStack(alignment: .topLeading) {
                 if viewModel.textToSpeak.isEmpty {
                     Text("Seslendirmek istediğiniz metni buraya yazın...")
                         .foregroundColor(.gray)
                         .padding(.top, 8)
                         .padding(.leading, 5)
                 }
                 
                 TextEditor(text: $viewModel.textToSpeak)
                     .focused($isFocused)
                     .frame(height: 200)
                     .padding(4)
                     .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
             }
             .padding()
             
             Spacer()
             
             HStack(spacing : 20) {
                 
                 Button(action: {
                     viewModel.clearText()
                 }) {
                     HStack {
                         Image(systemName: "trash")
                         Text("Temizle")
                     }
                     
                     .frame(maxWidth: .infinity)
                     .padding()
                     .background(Color.red.opacity(0.8))
                     .foregroundColor(.white)
                     .cornerRadius(10)
                 }
                 
                 Button(action: {
                     viewModel.speak()
                     isFocused = false
                 }) {
                     HStack {
                         Image(systemName: "speaker.wave.2.fill")
                         Text("Seslendir")
                     }
                     
                     .frame(maxWidth: .infinity)
                     .padding()
                     .background(Color.blue)
                     .foregroundColor(.white)
                     .cornerRadius(10)
                 }
             }
             .padding(.horizontal)
             .padding(.bottom,30)
         }
         .padding()
         
         .onTapGesture {
             isFocused = false
         }
    }
}
