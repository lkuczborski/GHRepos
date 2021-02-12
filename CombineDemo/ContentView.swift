//
//  ContentView.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import SwiftUI

struct ContentView: View {
        
    @StateObject var viewModel = RepositoryListViewModel()
    
    var body: some View {
        if viewModel.repositories.isEmpty {
            Text("Loading repos...")
                .font(.title3)
                .padding()
                .onAppear(perform: {
                    viewModel.getRepositories(for: "apple")
                })
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.repositories) { repo in
                        VStack {
                            Text(repo.name)
                                .font(.headline)
                                .padding()
                            if let description = repo.description {
                                Text(description)
                                    .font(.subheadline)
                                    .padding()
                            }
                        }
                    }
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
