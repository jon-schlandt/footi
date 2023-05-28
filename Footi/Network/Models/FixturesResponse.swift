//
//  FixturesResponse.swift
//  Footi
//
//  Created by Jon Schlandt on 1/5/23.
//

import Foundation

struct FixturesResponse: Codable {
    let errors: [ApiError]
    let results: Int
    let paging: ApiPaging
    let response: [Fixture]
}

struct Fixture: Codable {
    var overview: FixtureOverview
    var league: FixtureLeague
    var matchup: FixtureMatchup
    var score: FixtureScore
    var timeline: ScoreTimeline
    
    enum CodingKeys: String, CodingKey {
        case overview = "fixture"
        case league
        case matchup = "teams"
        case score = "goals"
        case timeline = "score"
    }
}

struct FixtureOverview: Codable {
    var id: Int
    var timezone: String
    var date: String
    var status: FixtureStatus
}

struct FixtureLeague: Codable {
    var id: Int
    var season: Int
    var matchday: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case season
        case matchday = "round"
    }
}

struct FixtureStatus: Codable {
    var short: String
    var long: String
    var type: FixtureStatusType?
    var minutesPlayed: Int?
    
    enum CodingKeys: String, CodingKey {
        case short
        case long
        case minutesPlayed = "elapsed"
    }
}

struct FixtureMatchup: Codable {
    var home: MatchupSide
    var away: MatchupSide
}

struct MatchupSide: Codable {
    var id: Int
    var name: String
    var logo: String
    var isWinner: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logo
        case isWinner = "winner"
    }
}

struct ScoreTimeline: Codable {
    var halftime: FixtureScore
    var fulltime: FixtureScore
    var extratime: FixtureScore
    var penalties: FixtureScore
    
    enum CodingKeys: String, CodingKey {
        case halftime
        case fulltime
        case extratime
        case penalties = "penalty"
    }
}

struct FixtureScore: Codable {
    var home: Int?
    var away: Int?
}
