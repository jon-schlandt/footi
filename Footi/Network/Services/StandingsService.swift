//
//  StandingsService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/24/23.
//

import Foundation

protocol StandingsServiceable {
    func getStandingsBy(leagueId: Int, season: Int) async -> [Standing]
    func getMockStandings(for leagueId: Int, season: Int) -> [Standing]
}

struct StandingsService: HTTPClient, StandingsServiceable {
    
    // MARK: Public methods
    
    public func getStandingsBy(leagueId: Int, season: Int) async -> [Standing] {
        let endpoint = StandingsEndpoint.byLeagueAndSeason(leagueId: leagueId, season: season)
        
        let response = try? (await sendRequest(to: endpoint, expect: StandingsResponse.self)).get()
        let standings = response?.toBlModels()
        if let standings = standings {
            return standings
        }
        
        return [Standing]()
    }
    
    public func getMockStandings(for leagueId: Int, season: Int) -> [Standing] {
        let responseModels = JSONLoader
            .loadJSONData(from: "standings-\(leagueId)-\(season)", decodingType: StandingsResponse.self)
        
        return responseModels?.toBlModels() ?? [Standing]()
    }
}
