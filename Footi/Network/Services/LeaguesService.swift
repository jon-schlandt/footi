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
    
    // MARK: Public methods
    
    public func getLeagueBy(leagueId: Int) async -> League? {
        let endpoint = LeaguesEndpoint.byId(leagueId: leagueId)
        let leagues = try? (await sendRequest(to: endpoint, expect: LeaguesResponse.self)).get()
        
        return leagues?.toBlModels().first
    }
    
    public func getMockLeague(leagueId: Int) -> League? {
        let leagues = JSONLoader.loadJSONData(from: "league-\(leagueId)", decodingType: LeaguesResponse.self)
        return leagues?.toBlModels().first
    }
}
