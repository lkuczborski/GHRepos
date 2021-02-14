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
        let fullName = model.fullName
        return fullName.components(separatedBy: "/").last ?? fullName
    }
    
    var description: String? {
        model.description
    }
}

extension RepositoryViewModel {
    static var preview: RepositoryViewModel {
        RepositoryViewModel(Repository.preview)
    }
}
