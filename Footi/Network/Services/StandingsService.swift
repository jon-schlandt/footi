//
//  StandingsService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/24/23.
//

import Foundation

protocol StandingsServiceable {
    func getStandingsBy(leagueId: Int, season: Int) async -> [Standing]?
}

struct StandingsService: HTTPClient, StandingsServiceable {
    
    func getStandingsBy(leagueId: Int, season: Int) async -> [Standing]? {
        let endpoint = StandingsEndpoint.byLeagueAndSeason(leagueId: leagueId, season: season)
        let response = try? (await sendRequest(to: endpoint, expect: Standings.self)).get().response.first
        
        return response?["league"]?.standings.first
    }
}
