//
//  GitHubService.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import Foundation
import Combine

final class GitHubService {
    
    static let baseUrl: String = "https://api.github.com"
    
    enum Paths {
        static let users: String = "/users"
        static let repositories: String = "/repos"
    }
    
    let urlSession: URLSession
    var bag = Set<AnyCancellable>()
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    static var shared: GitHubService {
        GitHubService()
    }
    
    func getRepositoryList(for user: String, completionHandler: @escaping (Result<[Repository], Error>) -> Void) {
        let urlString = "\(GitHubService.baseUrl)\(Paths.users)/\(user)\(Paths.repositories)"
        let url = URL(string: urlString)!
        let decoder = JSONDecoder()
        urlSession
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Repository].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        completionHandler(.failure(error))
                    case .finished:
                        break
                    }
                },
                receiveValue: { repos in
                    completionHandler(.success(repos))
                })
            .store(in: &bag)
            
    }
    
}
