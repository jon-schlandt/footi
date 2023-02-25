//
//  FixturesEndpoint.swift
//  Footi
//
//  Created by Jon Schlandt on 2/23/23.
//

import Foundation

enum FixturesEndpoint {
    case byDateRange(leagueId: Int, season: Int, from: String, to: String)
    case byDateRangeAndStatus(leagueId: Int, season: Int, from: String, to: String, status: String)
}

extension FixturesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .byDateRange, .byDateRangeAndStatus:
            return "/v3/fixtures"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .byDateRange(let leagueId, let season, let from, let to):
            return [
                URLQueryItem(name: "league", value: String(leagueId)),
                URLQueryItem(name: "season", value: String(season)),
                URLQueryItem(name: "from", value: from),
                URLQueryItem(name: "to", value: to)
            ]
        case .byDateRangeAndStatus(let leagueId, let season, let from, let to, let status):
            return [
                URLQueryItem(name: "league", value: String(leagueId)),
                URLQueryItem(name: "season", value: String(season)),
                URLQueryItem(name: "from", value: from),
                URLQueryItem(name: "to", value: to),
                URLQueryItem(name: "status", value: status)
            ]
        }
    }
}
