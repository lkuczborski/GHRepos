//
//  User.swift
//  GHRepos
//
//  Created for user search autocomplete
//

import Foundation

struct UserSearchResponse: Decodable, Sendable {
    let items: [User]
}

struct User: Decodable, Identifiable, Sendable {
    let id: Int
    let login: String

    enum CodingKeys: String, CodingKey {
        case id
        case login
    }
}
