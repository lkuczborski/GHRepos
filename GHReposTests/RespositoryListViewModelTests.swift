//
//  CombineDemoTests.swift
//  CombineDemoTests
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

@testable import CombineDemo
import XCTest

final class RespositoryListViewModelTests: XCTestCase {

    var sut: RepositoryListViewModel!
    var serviceMock: GitHubServiceMock!

    override func setUp() {
        serviceMock = GitHubServiceMock()
        sut = RepositoryListViewModel(service: serviceMock)
    }

    override func tearDown() {
        sut = nil
        serviceMock = nil
    }

    func test_getRepositories() {
        // Arrange
        let testUser = "test"
        
        // Act
        sut.getRepositories(for: testUser)
        
        // Asert
        XCTAssertEqual(serviceMock.user, testUser)
        XCTAssertEqual(serviceMock.getRepositoryListCallsCount, 1)
        XCTAssertEqual(sut.repositories.count, 1)
        XCTAssertEqual(sut.repositories.first, RepositoryViewModel.mock)
    }
}
