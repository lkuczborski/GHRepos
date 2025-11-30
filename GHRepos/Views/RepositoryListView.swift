//
//  ContentView.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import SwiftUI

struct RepositoryListView: View {
    private var viewModel: RepositoryListViewModel
    @State private var searchHistory = SearchHistory()
    @State var user: String = "apple"
    @State private var suggestions: [String] = []
    @State private var showSuggestions = false
    @State private var debounceTask: Task<Void, Never>?
    @FocusState private var isTextFieldFocused: Bool
    private let service: APIService

    init(viewModel: RepositoryListViewModel = RepositoryListViewModel(), service: APIService = GitHubService.shared) {
        self.viewModel = viewModel
        self.service = service
    }

    var body: some View {
        NavigationView {
            listView
        }
        .onAppear {
            isTextFieldFocused = true
            getRepositories()
        }
        .onChange(of: isTextFieldFocused) { _, isFocused in
            if !isFocused {
                showSuggestions = false
            }
        }
    }
    
    // MARK: - Views
    
    private var userTextField: some View {
        TextField("GitHub User", text: $user)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.center)
            .focused($isTextFieldFocused)
            .onSubmit {
                handleSubmit()
            }
            .onChange(of: user) { _, newValue in
                handleTextChange(newValue)
            }
            .padding([.top, .bottom], 10)
    }
    
    private var listView: some View {
        ZStack(alignment: .top) {
            List {
                Section(header: userTextField) {
                    ForEach(viewModel.repositories) { repo in
                        RepositoryRow(viewModel: repo)
                    }
                }
            }
            .listStyle(.plain)
            .listSectionSeparator(.hidden)
            .refreshable {
                getRepositories()
            }
            .navigationTitle("Repositories")

            if showSuggestions && !suggestions.isEmpty {
                suggestionsView
            }
        }
    }

    private var suggestionsView: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 60) // Offset below the textfield

            VStack(alignment: .leading, spacing: 0) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button(action: {
                        selectSuggestion(suggestion)
                    }) {
                        HStack {
                            if isFromHistory(suggestion) {
                                Image(systemName: "clock.arrow.circlepath")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                            Text(suggestion)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                    }
                    .background(Color(.systemBackground))

                    if suggestion != suggestions.last {
                        Divider()
                            .padding(.leading, isFromHistory(suggestion) ? 40 : 12)
                    }
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 16)

            Spacer()
        }
    }

    private func isFromHistory(_ suggestion: String) -> Bool {
        searchHistory.recentSearches.contains(where: { $0.lowercased() == suggestion.lowercased() })
    }
    
    // MARK: - Actions

    func getRepositories() {
        Task {
            try await viewModel.getRespositories(for: user)
        }
    }

    private func handleTextChange(_ newValue: String) {
        // Cancel previous debounce task
        debounceTask?.cancel()

        // Show search history suggestions immediately
        let historySuggestions = searchHistory.getSuggestions(for: newValue)
        suggestions = historySuggestions
        showSuggestions = !newValue.isEmpty && isTextFieldFocused

        // Debounce the GitHub user search (300ms delay)
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms

            guard !Task.isCancelled else { return }

            if !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                await searchGitHubUsers(query: newValue)
            }
        }
    }

    private func searchGitHubUsers(query: String) async {
        do {
            let users = try await service.searchUsers(query: query)
            let usernames = users.map { $0.login }

            // Combine search history with GitHub users, avoiding duplicates
            let historySuggestions = searchHistory.getSuggestions(for: query)
            var combinedSuggestions = historySuggestions

            for username in usernames {
                if !combinedSuggestions.contains(where: { $0.lowercased() == username.lowercased() }) {
                    combinedSuggestions.append(username)
                }
            }

            suggestions = combinedSuggestions
        } catch {
            // On error, keep showing search history suggestions
            print("Error searching users: \(error)")
        }
    }

    private func handleSubmit() {
        debounceTask?.cancel()
        showSuggestions = false

        let trimmedUser = user.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedUser.isEmpty {
            searchHistory.addSearch(trimmedUser)
            getRepositories()
        }
    }

    private func selectSuggestion(_ suggestion: String) {
        debounceTask?.cancel()
        user = suggestion
        showSuggestions = false
        searchHistory.addSearch(suggestion)
        getRepositories()
    }
}

struct RepositoryListView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryListView(viewModel: RepositoryListViewModel.mock)
    }
}
