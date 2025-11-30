//
//  SearchHistory.swift
//  GHRepos
//
//  Created for autocompletion feature
//

import Foundation

@MainActor
final class SearchHistory: ObservableObject {
    private let userDefaultsKey = "github_user_search_history"
    private let maxHistoryCount = 10

    @Published private(set) var recentSearches: [String] = []

    init() {
        loadHistory()
    }

    func addSearch(_ username: String) {
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        // Remove if already exists to avoid duplicates
        recentSearches.removeAll { $0.lowercased() == trimmed.lowercased() }

        // Add to beginning
        recentSearches.insert(trimmed, at: 0)

        // Keep only the most recent searches
        if recentSearches.count > maxHistoryCount {
            recentSearches = Array(recentSearches.prefix(maxHistoryCount))
        }

        saveHistory()
    }

    func getSuggestions(for query: String) -> [String] {
        guard !query.isEmpty else { return recentSearches }

        let lowercasedQuery = query.lowercased()
        return recentSearches.filter { $0.lowercased().contains(lowercasedQuery) }
    }

    func clearHistory() {
        recentSearches = []
        saveHistory()
    }

    // MARK: - Private Methods

    private func loadHistory() {
        if let saved = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] {
            recentSearches = saved
        }
    }

    private func saveHistory() {
        UserDefaults.standard.set(recentSearches, forKey: userDefaultsKey)
    }
}
