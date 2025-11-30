//
//  ContentView.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import SwiftUI

struct RepositoryListView: View {
    @ObservedObject private var viewModel: RepositoryListViewModel
    @StateObject private var searchHistory = SearchHistory()
    @State var user: String = "apple"
    @State private var debounceTask: Task<Void, Never>?
    @State private var suggestions: [String] = []
    @State private var showSuggestions = false
    @FocusState private var isTextFieldFocused: Bool

    init(viewModel: RepositoryListViewModel = RepositoryListViewModel()) {
        self.viewModel = viewModel
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
                .frame(height: 110) // Offset below the textfield

            VStack(alignment: .leading, spacing: 0) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button(action: {
                        selectSuggestion(suggestion)
                    }) {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
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
                            .padding(.leading, 40)
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
    
    // MARK: - Actions

    func getRepositories() {
        Task {
            try await viewModel.getRespositories(for: user)
        }
    }

    private func handleTextChange(_ newValue: String) {
        // Cancel previous debounce task
        debounceTask?.cancel()

        // Show suggestions immediately as user types
        suggestions = searchHistory.getSuggestions(for: newValue)
        showSuggestions = !newValue.isEmpty && isTextFieldFocused

        // Debounce the repository fetch (500ms delay)
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 500ms

            guard !Task.isCancelled else { return }

            if !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                getRepositories()
            }
        }
    }

    private func handleSubmit() {
        showSuggestions = false
        debounceTask?.cancel()

        let trimmedUser = user.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedUser.isEmpty {
            searchHistory.addSearch(trimmedUser)
            getRepositories()
        }
    }

    private func selectSuggestion(_ suggestion: String) {
        user = suggestion
        showSuggestions = false
        debounceTask?.cancel()
        searchHistory.addSearch(suggestion)
        getRepositories()
    }
}

struct RepositoryListView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryListView(viewModel: RepositoryListViewModel.mock)
    }
}
