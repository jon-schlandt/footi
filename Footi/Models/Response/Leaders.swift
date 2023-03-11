//
//  TopScorers.swift
//  Footi
//
//  Created by Jon Schlandt on 2/22/23.
//

import Foundation

struct Leaders: Codable {
    let errors: [ApiError]
    let results: Int
    let paging: ApiPaging
    let response: [Leader]
}

struct Leader: Codable {
    var overview: LeaderOverview
    var stats: [LeaderStats]
    
    enum CodingKeys: String, CodingKey {
        case overview = "player"
        case stats = "statistics"
    }
}

struct LeaderOverview: Codable {
    var id: Int
    var displayName: String
    var firstName: String
    var lastName: String
    var image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "name"
        case firstName = "firstname"
        case lastName = "lastname"
        case image = "photo"
    }
}

struct LeaderStats: Codable {
    var club: Club
    var goals: LeaderGoals
    var cards: LeaderCards
    
    enum CodingKeys: String, CodingKey {
        case club = "team"
        case goals
        case cards
    }
}

struct LeaderGoals: Codable {
    var scored: Int?
    var assisted: Int?
    
    enum CodingKeys: String, CodingKey {
        case scored = "total"
        case assisted = "assists"
    }
}

struct LeaderCards: Codable {
    var yellow: Int?
    var red: Int?
}
