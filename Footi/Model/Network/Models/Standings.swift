//
//  Standings.swift
//  Footi
//
//  Created by Jon Schlandt on 1/5/23.
//

import Foundation

struct Standings: Codable {
    let errors: [ApiError]
    let results: Int
    let paging: ApiPaging
    let response: [[String : LeagueStandings]]
}

struct LeagueStandings: Codable {
    var league: String
    var season: Int
    var standings: [[Standing]]
    
    enum CodingKeys: String, CodingKey {
        case league = "name"
        case season
        case standings
    }
}

struct Standing: Codable {
    var rank: Int
    var club: Club
    var points: Int
    var goalDifference: Int
    var form: String
    var record: ClubRecord
    
    enum CodingKeys: String, CodingKey {
        case rank
        case club = "team"
        case points
        case goalDifference = "goalsDiff"
        case form
        case record = "all"
    }
}

struct ClubRecord: Codable {
    var played: Int
    var won: Int
    var drew: Int
    var lost: Int
    var goals: ClubGoals
    
    enum CodingKeys: String, CodingKey {
        case played
        case won = "win"
        case drew = "draw"
        case lost = "lose"
        case goals
    }
}

struct ClubGoals: Codable {
    var scored: Int
    var conceded: Int
    
    enum CodingKeys: String, CodingKey {
        case scored = "for"
        case conceded = "against"
    }
}
