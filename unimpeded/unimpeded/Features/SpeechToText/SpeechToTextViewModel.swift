//
//  SpeechToTextViewModel.swift
//  unimpeded
//
//  Created by Berat Yükselen on 17.11.2025.
//

import Foundation
import Speech
import AVFoundation

class SpeechToTextViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var transcribedText: String = "Konuşmanızı metne dönüştürmek için butona basın..."
    @Published var isRecording: Bool = false
    @Published var errorMessage: String?
    @Published var audioLevel: CGFloat = 0.0
    
    // MARK: - Apple Speech Properties
    
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
                    print("Erişim izni tamam.")
                default:
                    self.errorMessage = "Konuşma tanıma izni verilmedi."
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
            // .measurement modu ses analizini daha ham verir, .default görselleştirme için daha iyidir
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            self.errorMessage = "Ses oturumu hatası: \(error.localizedDescription)"
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Request oluşturulamadı") }
        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if let result = result {
                self.transcribedText = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.stopAudioEngine()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                DispatchQueue.main.async {
                    self.isRecording = false
                    self.audioLevel = 0.0
                }
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        // Buffer size'ı biraz düşürdük ki daha sık tetiklensin
        inputNode.installTap(onBus: 0, bufferSize: 512, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
            
            // *** GÜNCEL SES SEVİYESİ HESAPLAMA ***
            if let channelData = buffer.floatChannelData {
                let channelDataArray = channelData.pointee
                let frameLength = Int(buffer.frameLength)
                
                // RMS (Root Mean Square) daha doğal bir ses dalgalanması verir
                var sum: Float = 0
                for i in 0..<frameLength {
                    let sample = channelDataArray[i]
                    sum += sample * sample
                }
                let rms = sqrt(sum / Float(frameLength))
                
                // Desibel yerine lineer bir büyüme faktörü kullanalım
                // RMS genelde 0.001 - 0.1 arasında gelir, bunu görünür yapmak için çarpıyoruz.
                let boost: Float = 15.0
                let visualLevel = min(1.0, rms * boost)
                
                DispatchQueue.main.async {
                    // Animasyonun titrememesi için yumuşak geçiş (Linear Interpolation)
                    self.audioLevel = self.audioLevel * 0.6 + CGFloat(visualLevel) * 0.4
                }
            }
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            DispatchQueue.main.async {
                self.isRecording = true
                self.transcribedText = "Dinliyorum..."
            }
        } catch {
            self.errorMessage = "Motor başlatılamadı: \(error.localizedDescription)"
        }
    }
    
    private func stopTranscription() {
        stopAudioEngine()
        recognitionRequest?.endAudio()
        DispatchQueue.main.async {
            self.isRecording = false
            self.audioLevel = 0.0
        }
    }
    
    private func stopAudioEngine() {
        if audioEngine.isRunning {
            audioEngine.stop()
        }
    }
}
