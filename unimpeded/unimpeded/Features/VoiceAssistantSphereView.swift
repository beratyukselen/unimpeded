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
    let audioLevel: CGFloat
    let agentKey: String

    private var idleFilename: String { "\(agentKey)_idle" }
    private var speakingFilename: String { "\(agentKey)_speaking" }

    var body: some View {
        Group {
            switch state {
            case .idle:
                LottieView(filename: idleFilename, loopMode: .loop)
                    .scaleEffect(1.0)
                    
            case .speaking:
                LottieView(filename: speakingFilename, loopMode: .loop)
                    .scaleEffect(0.9 + (audioLevel * 0.4))
                    .animation(.linear(duration: 0.1), value: audioLevel)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
