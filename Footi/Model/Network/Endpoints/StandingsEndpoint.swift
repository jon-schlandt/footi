//
//  StandingsEndpoint.swift
//  Footi
//
//  Created by Jon Schlandt on 2/23/23.
//

import Foundation

enum StandingsEndpoint {
    case byLeagueAndSeason(leagueId: Int, season: Int)
}

extension StandingsEndpoint: Endpoint {
    var path: String {
        switch self {
        case .byLeagueAndSeason:
            return "/v3/standings"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .byLeagueAndSeason(let leagueId, let season):
            return [
                URLQueryItem(name: "league", value: String(leagueId)),
                URLQueryItem(name: "season", value: String(season))
            ]
        }
    }
}
