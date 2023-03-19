//
//  StandingsService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/24/23.
//

import Foundation

protocol StandingsServiceable {
    func getLeagueStandingsBy(leagueId: Int, season: Int) async -> LeagueStandings?
}

struct StandingsService: HTTPClient, StandingsServiceable {
    
    func getLeagueStandingsBy(leagueId: Int, season: Int) async -> LeagueStandings? {
        let endpoint = StandingsEndpoint.byLeagueAndSeason(leagueId: leagueId, season: season)
        let standings = try? (await sendRequest(to: endpoint, expect: Standings.self)).get().response.first
        
        return standings?["league"]
    }
}
