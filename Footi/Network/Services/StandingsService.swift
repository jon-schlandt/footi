//
//  StandingsService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/24/23.
//

import Foundation

protocol StandingsServiceable {
    func getStandingsBy(leagueId: Int, season: Int) async -> Result<Standings, RequestError>
}

struct StandingsService: HTTPClient, StandingsServiceable {
    func getStandingsBy(leagueId: Int, season: Int) async -> Result<Standings, RequestError> {
        let endpoint = StandingsEndpoint.byLeagueAndSeason(leagueId: leagueId, season: season)
        return await sendRequest(to: endpoint, expect: Standings.self)
    }
}
