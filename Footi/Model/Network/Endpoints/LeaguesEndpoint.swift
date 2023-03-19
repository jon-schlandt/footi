//
//  LeaguesEndpoint.swift
//  Footi
//
//  Created by Jon Schlandt on 2/22/23.
//

import Foundation

enum LeaguesEndpoint {
    case byId(leagueId: Int)
}

extension LeaguesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .byId:
            return "/v3/leagues"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .byId(let leagueId):
            return [
                URLQueryItem(name: "id", value: String(leagueId))
            ]
        }
    }
}
