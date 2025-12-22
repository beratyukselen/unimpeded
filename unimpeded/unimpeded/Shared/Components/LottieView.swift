//
//  LottieView.swift
//  unimpeded
//
//  Created by Berat Yükselen on 4.12.2025.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    var filename: String
    var loopMode: LottieLoopMode = .loop
    var speed: CGFloat = 1.0
    var contentMode: UIView.ContentMode = .scaleAspectFit
    var isPlaying: Bool = true

    func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView(name: filename, bundle: .main)
        
        view.accessibilityIdentifier = filename
        
        view.loopMode = loopMode
        view.animationSpeed = speed
        view.contentMode = contentMode
        view.backgroundBehavior = .pauseAndRestore
        view.backgroundColor = .clear
        
        if isPlaying { view.play() }
        
        return view
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        if uiView.accessibilityIdentifier != filename {
            
            if let animation = LottieAnimation.named(filename) {
                uiView.animation = animation
                uiView.accessibilityIdentifier = filename
                uiView.play()
            }
        }
        
        uiView.loopMode = loopMode
        uiView.animationSpeed = speed
        uiView.contentMode = contentMode
        
        if isPlaying && !uiView.isAnimationPlaying {
            uiView.play()
        } else if !isPlaying && uiView.isAnimationPlaying {
            uiView.pause()
        }
    }
}
