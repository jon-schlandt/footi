//
//  LeadersService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/24/23.
//

import Foundation

protocol LeadersServiceable {
    func getTopGoals(leagueId: Int, season: Int) async -> [Leader]?
    func getTopAssists(leagueId: Int, season: Int) async -> [Leader]?
    func getTopYellowCards(leagueId: Int, season: Int) async -> [Leader]?
    func getTopRedCards(leagueId: Int, season: Int) async -> [Leader]?
}

struct LeadersService: HTTPClient, LeadersServiceable {
    
    func getTopGoals(leagueId: Int, season: Int) async -> [Leader]? {
        let endpoint = LeadersEndpoint.topGoals(leagueId: leagueId, season: season)
        let topGoals = try? (await sendRequest(to: endpoint, expect: Leaders.self)).get().response
        
        return topGoals
    }
    
    func getTopAssists(leagueId: Int, season: Int) async -> [Leader]? {
        let endpoint = LeadersEndpoint.topAssists(leagueId: leagueId, season: season)
        let topAssists = try? (await sendRequest(to: endpoint, expect: Leaders.self)).get().response
        
        return topAssists
    }
    
    func getTopYellowCards(leagueId: Int, season: Int) async -> [Leader]? {
        let endpoint = LeadersEndpoint.topYellowCards(leagueId: leagueId, season: season)
        let topYellowCards = try? (await sendRequest(to: endpoint, expect: Leaders.self)).get().response
        
        return topYellowCards
    }
    
    func getTopRedCards(leagueId: Int, season: Int) async -> [Leader]? {
        let endpoint = LeadersEndpoint.topRedCards(leagueId: leagueId, season: season)
        let topRedCards = try? (await sendRequest(to: endpoint, expect: Leaders.self)).get().response
        
        return topRedCards
    }
}
