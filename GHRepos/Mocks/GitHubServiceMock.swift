//
//  GitHubServiceMock.swift
//  CombineDemoTests
//
//  Created by Łukasz Kuczborski on 28/03/2021.
//

import Foundation

@MainActor
final class GitHubServiceMock: APIService {
    var user: String = ""
    var getRepositoryListCallsCount: Int = 0

    func getRepositoryList(for user: String) async throws -> [Repository] {
        self.user = user
        getRepositoryListCallsCount += 1
        return [Repository.mock]
    }

    func searchUsers(query: String) async throws -> [User] {
        return []
    }
}
