//
//  LeaguesService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/22/23.
//

import Foundation

protocol LeaguesServiceable {
    func getLeaguesBy(leagueId: Int) async -> Result<Leagues, RequestError>
}

struct LeaguesService: HTTPClient, LeaguesServiceable {
    func getLeaguesBy(leagueId: Int) async -> Result<Leagues, RequestError> {
        let endpoint = LeaguesEndpoint.byId(leagueId: leagueId)
        return await sendRequest(to: endpoint, expect: Leagues.self)
    }
}
