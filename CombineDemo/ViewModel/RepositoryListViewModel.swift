//
//  RepositoryViewModel.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import Foundation

final class RepositoryListViewModel: ObservableObject {

    @Published var repositories = [RepositoryViewModel]()
    private let service: GitHubService
    
    init(service: GitHubService = GitHubService.shared) {
        self.service = service
    }
        
    func getRepositories(for user: String) {
        service.getRepositoryList(for: user) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let repositories):
                self.repositories = repositories.map(RepositoryViewModel.init)
            }
        }
    }
    
}
