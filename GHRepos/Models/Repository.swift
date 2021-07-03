//
//  Repository.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import Foundation

struct Repository: Decodable, Equatable {
    let id: Int
    let name: String
    let description: String?
    let starsCount: Int
    let forksCount: Int
    let `private`: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case starsCount = "stargazers_count"
        case forksCount = "forks_count"
        case `private`
    }
}

extension Repository {
    static var mock: Repository {
        Repository(id: 0,
                   name: "Test Repository",
                   description: "This is some long description. This is some long description.",
                   starsCount: 10,
                   forksCount: 68,
                   private: false)
    }
}
