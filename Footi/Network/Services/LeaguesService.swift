//
//  LeaguesService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/22/23.
//

import Foundation

protocol LeaguesServiceable {
    func getLeagueBy(leagueId: Int) async -> League?
    func getMockLeague(leagueId: Int) -> League?
}

struct LeaguesService: HTTPClient, LeaguesServiceable {
    
    func getLeagueBy(leagueId: Int) async -> League? {
        let endpoint = LeaguesEndpoint.byId(leagueId: leagueId)
        let league = try? (await sendRequest(to: endpoint, expect: Leagues.self)).get().response.first
        
        return league
    }
    
    func getMockLeague(leagueId: Int) -> League? {
        return JSONLoader.loadJSONData(from: "league-\(leagueId)", decodingType: Leagues.self)?.response.first
    }
}
