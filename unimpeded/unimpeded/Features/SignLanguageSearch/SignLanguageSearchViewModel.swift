//
//  SignLanguageSearchViewModel.swift
//  unimpeded
//
//  Created by Berat Yükselen on 22.12.2025.
//

import Foundation
import Combine

class SignLanguageSearchViewModel: ObservableObject {
    
    @Published var searchText: String = "" {
        didSet {
            filterResults()
        }
    }
    
    @Published var searchResults: [SignWord] = []
    
    private var allSignWords: [SignWord] = []
    
    init() {
        loadData()
    }
    
    private func loadData() {
        guard let url = Bundle.main.url(forResource: "SignLanguageData", withExtension: "json") else {
            print("Hata: JSON dosyası bulunamadı.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            self.allSignWords = try decoder.decode([SignWord].self, from: data)
            self.searchResults = allSignWords
            print("Veri yüklendi: \(allSignWords.count) kelime.")
        } catch {
            print("Hata: JSON decode edilemedi. \(error.localizedDescription)")
        }
    }
    
    private func filterResults() {
        if searchText.isEmpty {
            searchResults = allSignWords
        } else {
            searchResults = allSignWords.filter { sign in
                sign.word.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
