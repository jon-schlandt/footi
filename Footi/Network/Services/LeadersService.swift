//
//  LeadersService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/24/23.
//

import Foundation

protocol LeadersServiceable {
    func getTopGoals(leagueId: Int, season: Int) async -> Result<Leaders, RequestError>
    func getTopAssists(leagueId: Int, season: Int) async -> Result<Leaders, RequestError>
    func getTopYellowCards(leagueId: Int, season: Int) async -> Result<Leaders, RequestError>
    func getTopRedCards(leagueId: Int, season: Int) async -> Result<Leaders, RequestError>
}

struct LeadersService: HTTPClient, LeadersServiceable {
    func getTopGoals(leagueId: Int, season: Int) async -> Result<Leaders, RequestError> {
        let endpoint = LeadersEndpoint.topGoals(leagueId: leagueId, season: season)
        return await sendRequest(to: endpoint, expect: Leaders.self)
    }
    
    func getTopAssists(leagueId: Int, season: Int) async -> Result<Leaders, RequestError> {
        let endpoint = LeadersEndpoint.topAssists(leagueId: leagueId, season: season)
        return await sendRequest(to: endpoint, expect: Leaders.self)
    }
    
    func getTopYellowCards(leagueId: Int, season: Int) async -> Result<Leaders, RequestError> {
        let endpoint = LeadersEndpoint.topYellowCards(leagueId: leagueId, season: season)
        return await sendRequest(to: endpoint, expect: Leaders.self)
    }
    
    func getTopRedCards(leagueId: Int, season: Int) async -> Result<Leaders, RequestError> {
        let endpoint = LeadersEndpoint.topRedCards(leagueId: leagueId, season: season)
        return await sendRequest(to: endpoint, expect: Leaders.self)
    }
}
