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
        
        // View'a şu anki dosya adını "etiket" olarak yapıştırıyoruz
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
        // DÜZELTME: animation.name yerine, kaydettiğimiz etiketi (accessibilityIdentifier) kontrol ediyoruz
        if uiView.accessibilityIdentifier != filename {
            
            // Yeni animasyonu yükle
            if let animation = LottieAnimation.named(filename) {
                uiView.animation = animation
                // Yeni ismi etikete kaydet
                uiView.accessibilityIdentifier = filename
                uiView.play()
            }
        }
        
        // Diğer özellikleri güncelle
        uiView.loopMode = loopMode
        uiView.animationSpeed = speed
        uiView.contentMode = contentMode
        
        // Oynatma durumunu kontrol et
        if isPlaying && !uiView.isAnimationPlaying {
            uiView.play()
        } else if !isPlaying && uiView.isAnimationPlaying {
            uiView.pause()
        }
    }
}
