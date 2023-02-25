//
//  LeadersEndpoint.swift
//  Footi
//
//  Created by Jon Schlandt on 2/23/23.
//

import Foundation

enum LeadersEndpoint {
    case topGoals(leagueId: Int, season: Int)
    case topAssists(leagueId: Int, season: Int)
    case topYellowCards(leagueId: Int, season: Int)
    case topRedCards(leagueId: Int, season: Int)
}

extension LeadersEndpoint: Endpoint {
    var path: String {
        switch self {
        case .topGoals:
            return "/v3/players/topscorers"
        case .topAssists:
            return "/v3/players/topassists"
        case .topYellowCards:
            return "/v3/players/topyellowcards"
        case .topRedCards:
            return "/v3/players/topredcards"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .topGoals(let leagueId, let season):
            return [
                URLQueryItem(name: "league", value: String(leagueId)),
                URLQueryItem(name: "season", value: String(season))
            ]
        case .topAssists(let leagueId, let season):
            return [
                URLQueryItem(name: "league", value: String(leagueId)),
                URLQueryItem(name: "season", value: String(season))
            ]
        case .topYellowCards(let leagueId, let season):
            return [
                URLQueryItem(name: "league", value: String(leagueId)),
                URLQueryItem(name: "season", value: String(season))
            ]
        case .topRedCards(let leagueId, let season):
            return [
                URLQueryItem(name: "league", value: String(leagueId)),
                URLQueryItem(name: "season", value: String(season))
            ]
        }
    }
}
