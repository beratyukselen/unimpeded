//
//  TextToSpeechViewModel.swift
//  unimpeded
//
//  Created by Berat Yükselen on 19.11.2025.
//

import Foundation
import AVFoundation

class TextToSpeechViewModel: ObservableObject {
    
    @Published var textToSpeak: String = ""
    
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak() {
        
        guard !textToSpeak.isEmpty else { return }
        
        let utterance = AVSpeechUtterance(string: textToSpeak)
        
        utterance.voice = AVSpeechSynthesisVoice(language: "tr-TR")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate )
        }
        
        synthesizer.speak(utterance)
    }
    
    func clearText() {
        textToSpeak = ""
    }
}
