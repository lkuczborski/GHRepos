//
//  GitHubServiceMock.swift
//  CombineDemoTests
//
//  Created by Łukasz Kuczborski on 28/03/2021.
//

import Foundation

final class GitHubServiceMock: APIService {
    var user: String = ""
    var getRepositoryListCallsCount: Int = 0
    
    func getRepositoryList(for user: String, completionHandler: @escaping (Result<[Repository], Error>) -> Void) {
        self.user = user
        getRepositoryListCallsCount += 1
        completionHandler(.success([Repository.mock]))
    }
    
    func getRepositoryList(for user: String) async throws -> [Repository] {
        return [Repository.mock]
    }
}
