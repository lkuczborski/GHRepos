//
//  Repository.swift
//  CombineDemo
//
//  Created by Lukasz Kuczborski on 30/09/2020.
//

import Foundation

struct Repository: Codable {
    let id: Int
    let fullName: String
    let description: String?
    let `private`: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case description
        case `private`
    }
}
