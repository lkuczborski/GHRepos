//
//  RepositoryViewModel.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import Foundation
import UIKit
import Observation

@MainActor
@Observable
final class RepositoryListViewModel {

    var repositories = [RepositoryViewModel]()
    private let service: APIService

    init(service: APIService = GitHubService.shared) {
        self.service = service
    }

    func getRespositories(for user: String) async throws {
        let repositories = try await service.getRepositoryList(for: user)
        self.repositories = repositories.map(RepositoryViewModel.init)
    }
}

extension RepositoryListViewModel {
    static var mock: RepositoryListViewModel {
        RepositoryListViewModel(service: GitHubServiceMock())
    }
}
