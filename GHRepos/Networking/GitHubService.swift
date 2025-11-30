//
//  GitHubService.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import Foundation

protocol APIService: Sendable {
    func getRepositoryList(for user: String) async throws -> [Repository]
    func searchUsers(query: String) async throws -> [User]
}

final class GitHubService: APIService, Sendable {

    static let baseUrl: String = "https://api.github.com"

    private enum Paths {
        static let users: String = "/users"
        static let repositories: String = "/repos"
        static let searchUsers: String = "/search/users"
    }

    static var shared: GitHubService {
        GitHubService()
    }

    let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func getRepositoryList(for user: String) async throws -> [Repository] {
        let urlString = "\(Self.baseUrl)\(Paths.users)/\(user)\(Paths.repositories)"
        guard let url = URL(string: urlString) else { fatalError() }
        let (data, _) = try await urlSession.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode([Repository].self, from: data)
    }

    func searchUsers(query: String) async throws -> [User] {
        guard !query.isEmpty else { return [] }

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(Self.baseUrl)\(Paths.searchUsers)?q=\(encodedQuery)&per_page=10"
        guard let url = URL(string: urlString) else { fatalError() }
        let (data, _) = try await urlSession.data(from: url)
        let decoder = JSONDecoder()
        let response = try decoder.decode(UserSearchResponse.self, from: data)
        return response.items
    }
}
