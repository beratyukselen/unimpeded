//
//  SpeechToTextViewModel.swift
//  unimpeded
//
//  Created by Berat Yükselen on 17.11.2025.
//

import Foundation
import Speech

class SpeechToTextViewModel: ObservableObject {
    
    
    @Published var transcribedText: String = "Konuşmanızı metne dönüştürmek için butona basın..."
    @Published var isRecording: Bool = false
    @Published var errorMessage: String?
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "tr-TR"))
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    
    init() {
        requestSpeechAuthorization()
    }
    
    func toggleRecording() {
        if isRecording {
            stopTranscription()
        } else {
            startTranscription()
        }
    }
    
    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    print("Konuşma tanıma izni verildi.")
                case .denied:
                    self.errorMessage = "Konuşma tanıma izni reddedildi."
                case .restricted:
                    self.errorMessage = "Konuşma tanıma bu cihazda kısıtlanmış."
                case .notDetermined:
                    self.errorMessage = "Konuşma tanıma izni henüz verilmedi."
                @unknown default:
                    self.errorMessage = "Bilinmeyen bir yetki durumu oluştu."
                }
            }
        }
    }

    private func startTranscription() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            self.errorMessage = "Ses oturumu ayarlanamadı: \(error.localizedDescription)"
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("SFSpeechAudioBufferRecognitionRequest oluşturulamadı.")
        }
        
        let inputNode = audioEngine.inputNode
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if let result = result {
                
                self.transcribedText = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil

                DispatchQueue.main.async {
                    self.isRecording = false
                }
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in

            self.recognitionRequest?.append(buffer)
        }
  
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            DispatchQueue.main.async {
                self.isRecording = true
                self.transcribedText = "Dinliyorum..."
            }
        } catch {
            self.errorMessage = "Ses motoru başlatılamadı: \(error.localizedDescription)"
        }
    }
    
    private func stopTranscription() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        
        DispatchQueue.main.async {
            self.isRecording = false
            if self.transcribedText == "Dinliyorum..." {
                self.transcribedText = "Konuşmanızı metne dönüştürmek için butona basın..."
            }
        }
    }
}
