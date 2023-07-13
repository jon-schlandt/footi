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
    let response: [FixtureResponse]
}

struct FixtureResponse: Codable {
    var overview: FixtureOverviewResponse
    var league: FixtureLeagueResponse
    var matchup: FixtureMatchupResponse
    var score: FixtureScoreResponse
    var timeline: ScoreTimelineResponse
    
    enum CodingKeys: String, CodingKey {
        case overview = "fixture"
        case league
        case matchup = "teams"
        case score = "goals"
        case timeline = "score"
    }
}

struct FixtureOverviewResponse: Codable {
    var id: Int
    var timezone: String
    var date: String
    var status: FixtureStatusResponse
}

struct FixtureLeagueResponse: Codable {
    var id: Int
    var season: Int
    var matchday: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case season
        case matchday = "round"
    }
}

struct FixtureStatusResponse: Codable {
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

struct FixtureMatchupResponse: Codable {
    var home: MatchupSideResponse
    var away: MatchupSideResponse
}

struct MatchupSideResponse: Codable {
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

struct ScoreTimelineResponse: Codable {
    var halftime: FixtureScoreResponse
    var fulltime: FixtureScoreResponse
    var extratime: FixtureScoreResponse
    var penalties: FixtureScoreResponse
    
    enum CodingKeys: String, CodingKey {
        case halftime
        case fulltime
        case extratime
        case penalties = "penalty"
    }
}

struct FixtureScoreResponse: Codable {
    var home: Int?
    var away: Int?
}
