//
//  GitHubServiceMock.swift
//  CombineDemoTests
//
//  Created by Łukasz Kuczborski on 28/03/2021.
//

import Foundation

actor GitHubServiceMock: APIService {
    var user: String = ""
    var getRepositoryListCallsCount: Int = 0

    func getRepositoryList(for user: String) async throws -> [Repository] {
        self.user = user
        getRepositoryListCallsCount += 1
        return [Repository.mock]
    }
}
