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
        
        // MARK: - Audio Session Fix
        // Sesin ahize yerine hoparlörden çıkmasını sağlayan ayar.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // .playAndRecord: Uygulamada mikrofon da kullanıldığı için bu kategori şart.
            // .defaultToSpeaker: Sesi zorla hoparlöre yönlendirir.
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            print("Ses oturumu hatası: \(error.localizedDescription)")
        }
        
        // Konuşma ayarları
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: "tr-TR")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        // Zaten konuşuyorsa durdur, yenisine başla
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        synthesizer.speak(utterance)
    }
    
    func clearText() {
        textToSpeak = ""
    }
}
