//
//  VoiceAssistantSphereView.swift
//  unimpeded
//
//  Created by Berat Yükselen on 5.12.2025.
//

import Lottie
import SwiftUI

enum AssistantAnimationState {
    case idle
    case speaking
}

struct VoiceAssistantSphereView: View {
    let state: AssistantAnimationState
    let audioLevel: CGFloat // İsimlendirmeyi netleştirdim
    let agentKey: String

    private var idleFilename: String { "\(agentKey)_idle" }
    private var speakingFilename: String { "\(agentKey)_speaking" }

    var body: some View {
        // GeometryReader'ı kaldırdık, boyut kontrolü dışarıdan gelecek.
        Group {
            switch state {
            case .idle:
                LottieView(filename: idleFilename, loopMode: .loop)
                    .scaleEffect(1.0) // Sabit boyut
                    
            case .speaking:
                LottieView(filename: speakingFilename, loopMode: .loop)
                    // Ses yokken (0.0) bile %90 boyutta olsun, sesle %130'a kadar büyüsün
                    .scaleEffect(0.9 + (audioLevel * 0.4))
                    // Çok hızlı titremesin diye animasyon ekledik
                    .animation(.linear(duration: 0.1), value: audioLevel)
            }
        }
        // Lottie içeriğinin taşmasını önle
        .aspectRatio(1, contentMode: .fit)
    }
}
