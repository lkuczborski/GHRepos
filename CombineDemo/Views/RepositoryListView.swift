//
//  ContentView.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import SwiftUI

struct RepositoryListView: View {
    @ObservedObject private var viewModel: RepositoryListViewModel
    @State var user: String = "apple"
    
    init(viewModel: RepositoryListViewModel = RepositoryListViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            userTextField
            listView
        }
        .onAppear {
            getRepositories()
        }
    }
    
    // MARK: - Views
    
    private var userTextField: some View {
        TextField("GitHub User", text: $user)
            .autocapitalization(.none)
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.center)
            .onSubmit {
                getRepositories()
            }
            .padding([.leading, .trailing])
    }
    
    private var listView: some View {
        List {
            ForEach(viewModel.repositories) { repo in
                RepositoryRow(viewModel: repo)
            }
        }
        .listStyle(.plain)
        .refreshable {
            getRepositories()
        }
    }
    
    // MARK: - Actions
    
    func getRepositories() {
        async {
            try await viewModel.getRespositories(for: user)
        }
    }
}

struct RepositoryListView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryListView(viewModel: RepositoryListViewModel.mock)
    }
}
