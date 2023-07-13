//
//  StandingsResponse.swift
//  Footi
//
//  Created by Jon Schlandt on 1/5/23.
//

import Foundation

struct StandingsResponse: Codable {
    let errors: [ApiError]
    let results: Int
    let paging: ApiPaging
    let response: [[String : LeagueStandingsResponse]]
    
    public func toBlModels() -> [Standing] {
        let respModels = response.first?["league"]?.standings.first as? [StandingResponse]
        guard let respModels = respModels else {
            return [Standing]()
        }
        
        return respModels.map { rm in
            let blModel = Standing(
                position: StandingStat(value: rm.rank),
                clubLogo: URL(string: rm.club.logo)!,
                clubTitle: rm.club.name,
                matchesPlayed: StandingStat(value: rm.record.played),
                points: StandingStat(value: rm.points),
                goalDifference: StandingStat(value: rm.goalDifference),
                matchesWon: StandingStat(value: rm.record.won),
                matchesDrawn: StandingStat(value: rm.record.drew),
                matchesLost: StandingStat(value: rm.record.lost),
                goalsScored: StandingStat(value: rm.record.goals.scored),
                goalsConceded: StandingStat(value: rm.record.goals.conceded)
            )
            
            return blModel
        }
    }
}

struct LeagueStandingsResponse: Codable {
    var league: String
    var season: Int
    var standings: [[StandingResponse]]
    
    enum CodingKeys: String, CodingKey {
        case league = "name"
        case season
        case standings
    }
}

struct StandingResponse: Codable {
    var rank: Int
    var club: Club
    var points: Int
    var goalDifference: Int
    var form: String
    var record: ClubRecordResponse
    
    enum CodingKeys: String, CodingKey {
        case rank
        case club = "team"
        case points
        case goalDifference = "goalsDiff"
        case form
        case record = "all"
    }
}

struct ClubRecordResponse: Codable {
    var played: Int
    var won: Int
    var drew: Int
    var lost: Int
    var goals: ClubGoalsResponse
    
    enum CodingKeys: String, CodingKey {
        case played
        case won = "win"
        case drew = "draw"
        case lost = "lose"
        case goals
    }
}

struct ClubGoalsResponse: Codable {
    var scored: Int
    var conceded: Int
    
    enum CodingKeys: String, CodingKey {
        case scored = "for"
        case conceded = "against"
    }
}
