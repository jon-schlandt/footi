//
//  StandingsService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/24/23.
//

import Foundation

protocol StandingsServiceable {
    func getStandingsBy(leagueId: Int, season: Int) async -> [Standing]
}

struct StandingsService: HTTPClient, StandingsServiceable {
    
    func getStandingsBy(leagueId: Int, season: Int) async -> [Standing] {
        let endpoint = StandingsEndpoint.byLeagueAndSeason(leagueId: leagueId, season: season)
        
        let response = try? (await sendRequest(to: endpoint, expect: StandingsResponse.self)).get().response.first
        let standings = response?["league"]?.standings.first
        if let standings = standings {
            return standings
        }
        
        return [Standing]()
    }
}
