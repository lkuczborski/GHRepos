//
//  ContentView.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import SwiftUI

struct RepositoryListView: View {
        
    @ObservedObject private var viewModel: RepositoryListViewModel
    
    init(viewModel: RepositoryListViewModel = RepositoryListViewModel()) {
        self.viewModel = viewModel
    }
    
    var loadingText: some View {
        Text("Loading repos...")
            .title()
    }
    
    var body: some View {
        if viewModel.repositories.isEmpty {
            loadingText
                .onAppear(perform: {
                    viewModel.getRepositories(for: "codequest-eu")
                })
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.repositories,
                            content: RepositoryRow.init)
                }
            }
        }
    }
}

struct RepositoryListView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryListView(viewModel: RepositoryListViewModel.mock)
    }
}
