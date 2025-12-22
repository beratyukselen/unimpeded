//
//  SignLanguageSearchViewModel.swift
//  unimpeded
//
//  Created by Berat Yükselen on 5.12.2025.
//

import Foundation
import Combine

class SignLanguageSearchViewModel: ObservableObject {
    
    @Published var searchText: String = "" {
        didSet { filterResults() }
    }
    
    @Published var searchResults: [SignWord] = []
    @Published var learnedWordIDs: Set<Int> = []
    
    private var allSignWords: [SignWord] = []
    private let userDefaultsKey = "LearnedSignWords"
    
    var progress: Double {
        guard !allSignWords.isEmpty else { return 0.0 }
        return Double(learnedWordIDs.count) / Double(allSignWords.count)
    }
    
    init() {
        loadData()
        loadProgress()
    }
    
    private func loadData() {
        guard let url = Bundle.main.url(forResource: "SignLanguageData", withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: url)
            self.allSignWords = try JSONDecoder().decode([SignWord].self, from: data)
            self.searchResults = allSignWords
        } catch {
            print("Veri hatası: \(error.localizedDescription)")
        }
    }
    
    private func filterResults() {
        if searchText.isEmpty {
            searchResults = allSignWords
        } else {
            searchResults = allSignWords.filter { $0.word.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func loadProgress() {
        if let savedIDs = UserDefaults.standard.array(forKey: userDefaultsKey) as? [Int] {
            self.learnedWordIDs = Set(savedIDs)
        }
    }
    
    func markAsLearned(_ word: SignWord) {
        learnedWordIDs.insert(word.id)
        saveProgress()
    }
    
    func markAsUnlearned(_ word: SignWord) {
        learnedWordIDs.remove(word.id)
        saveProgress()
    }
    
    private func saveProgress() {
        UserDefaults.standard.set(Array(learnedWordIDs), forKey: userDefaultsKey)
    }

    func isLearned(_ word: SignWord) -> Bool {
        return learnedWordIDs.contains(word.id)
    }
}
