//
//  SignLanguageSearchView.swift
//  unimpeded
//
//  Created by Berat Yükselen on 19.11.2025.
//

import SwiftUI

struct SignLanguageSearchView: View {
    var body: some View {
        VStack {
            Image(systemName: "figure.wave")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundStyle(.orange)
            
            Text("İşaret Dili Arama (Yapım Aşamasında)")
                .font(.title)
        }
    }
}
