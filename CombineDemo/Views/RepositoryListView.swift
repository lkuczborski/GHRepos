//
//  ContentView.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import SwiftUI

struct RepositoryListView: View {
    @Namespace private var animation
    @ObservedObject private var viewModel: RepositoryListViewModel
    @State private var selectedRepo: RepositoryViewModel?
    
    init(viewModel: RepositoryListViewModel = RepositoryListViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if viewModel.repositories.isEmpty {
            loadingText
                .onAppear(perform: {
                    viewModel.getRepositories(for: "codequest-eu")
                })
        } else {
            if let repo = selectedRepo {
                detailsView(viewModel: repo)
            } else {
                listView
            }
        }
    }
    
    // MARK: - Views
    
    private var loadingText: some View {
        Text("Loading repos...")
            .title()
    }
    
    private var listView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.repositories) { repo in
                    RepositoryRow(viewModel: repo)
                        .matchedGeometryEffect(id: "Shape + \(repo.id)", in: animation)
                        .onTapGesture {
                            withAnimation {
                                selectedRepo = repo
                            }
                        }
                }
            }
        }
    }
    
    private func detailsView(viewModel: RepositoryViewModel) -> some View {
        VStack {
            RepositoryRow(viewModel: viewModel)
                .matchedGeometryEffect(id: "Shape + \(viewModel.id)", in: animation)
        }
        .onTapGesture {
            withAnimation {
                selectedRepo = nil
            }
        }
    }
}

struct RepositoryListView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryListView(viewModel: RepositoryListViewModel.mock)
    }
}
