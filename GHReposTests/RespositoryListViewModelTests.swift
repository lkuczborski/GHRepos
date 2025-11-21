//
//  CombineDemoTests.swift
//  CombineDemoTests
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

@testable import GHRepos
import XCTest

@MainActor
final class RespositoryListViewModelTests: XCTestCase {

    var sut: RepositoryListViewModel!
    var serviceMock: GitHubServiceMock!

    override func setUp() {
        super.setUp()
        serviceMock = GitHubServiceMock()
        sut = RepositoryListViewModel(service: serviceMock)
    }

    override func tearDown() {
        sut = nil
        serviceMock = nil
        super.tearDown()
    }

    func test_getRepositories() async throws {
        // Arrange
        let testUser = "test"

        // Act
        try await sut.getRespositories(for: testUser)

        // Assert
        XCTAssertEqual(serviceMock.user, testUser)
        XCTAssertEqual(serviceMock.getRepositoryListCallsCount, 1)
        XCTAssertEqual(sut.repositories.count, 1)
        XCTAssertEqual(sut.repositories.first, RepositoryViewModel.mock)
    }
}
