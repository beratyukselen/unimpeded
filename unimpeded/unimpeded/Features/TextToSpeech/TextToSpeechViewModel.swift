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
    
    private var bestTurkishVoice: AVSpeechSynthesisVoice?
    
    init() {
        findBestVoice()
    }
    
    private func findBestVoice() {
 
        let voices = AVSpeechSynthesisVoice.speechVoices()
 
        let turkishVoices = voices.filter { $0.language == "tr-TR" }
        
        if let premiumVoice = turkishVoices.first(where: { $0.quality == .premium }) {
            bestTurkishVoice = premiumVoice
            print("TTS: Premium ses seçildi: \(premiumVoice.name)")
        } else if let enhancedVoice = turkishVoices.first(where: { $0.quality == .enhanced }) {
            bestTurkishVoice = enhancedVoice
            print("TTS: Geliştirilmiş (Enhanced) ses seçildi: \(enhancedVoice.name)")
        } else {
            bestTurkishVoice = AVSpeechSynthesisVoice(language: "tr-TR")
            print("TTS: Standart ses seçildi")
        }
    }
    
    func speak() {
        
        guard !textToSpeak.isEmpty else { return }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            print("Ses oturumu hatası: \(error.localizedDescription)")
        }
        
        let utterance = AVSpeechUtterance(string: textToSpeak)
        
        if let voice = bestTurkishVoice {
            utterance.voice = voice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "tr-TR")
        }
        
        utterance.rate = 0.40
        utterance.pitchMultiplier = 0.95
        utterance.volume = 1.0
        utterance.postUtteranceDelay = 0.2
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        synthesizer.speak(utterance)
    }
    
    func clearText() {
        textToSpeak = ""
    }
}
