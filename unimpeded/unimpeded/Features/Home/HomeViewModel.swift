//
//  HomeViewModel.swift
//  unimpeded
//
//  Created by Berat Yükselen on 17.11.2025.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var title: String = "Engelsiz İletişim Asistanı"
    
    
    init() {
        print("HomeViewModel başlatıldı.")
    }
}
