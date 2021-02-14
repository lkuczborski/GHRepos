//
//  ContentView.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import SwiftUI

struct ContentView: View {
        
    @StateObject var viewModel = RepositoryListViewModel()
    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
