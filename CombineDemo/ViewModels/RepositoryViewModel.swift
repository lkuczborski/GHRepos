//
//  RepositoryViewModel.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import Foundation

final class RepositoryViewModel: Identifiable {
    let model: Repository
    
    init(_ model: Repository) {
        self.model = model
    }
    
    var name: String {
        model.name
    }
    
    var description: String? {
        model.description
    }
    
    var starsCount: Int {
        model.starsCount
    }
    
    var forksCount: Int {
        model.forksCount
    }
    
    var isPrivate: Bool {
        model.private
    }
}

extension RepositoryViewModel: Equatable {
    static func == (lhs: RepositoryViewModel, rhs: RepositoryViewModel) -> Bool {
        lhs.model == rhs.model
    }
}

extension RepositoryViewModel {
    static var mock: RepositoryViewModel {
        RepositoryViewModel(Repository.mock)
    }
}
