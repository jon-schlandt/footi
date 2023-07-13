//
//  LeadersService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/24/23.
//

import Foundation

protocol LeadersServiceable {
    func getLeaders(leagueId: Int, filterType: LeaderFilterType) async -> [Leader]
}

struct LeadersService: HTTPClient, LeadersServiceable {
    
    private let coreDataContext = CoreDataContext()
    
    // MARK: Public methods
    
    public func getLeaders(leagueId: Int, filterType: LeaderFilterType) async -> [Leader] {
        let currentSeason = await coreDataContext.fetchCurrentSeason(for: leagueId)
        guard let currentSeason = currentSeason else {
            return [Leader]()
        }
        
        switch filterType {
        case .goals:
            return await getTopGoals(for: leagueId, season: currentSeason)
        case .assists:
            return await getTopAssists(for: leagueId, season: currentSeason)
        case .yellowCards:
            return await getTopYellowCards(for: leagueId, season: currentSeason)
        case .redCards:
            return await getTopRedCards(for: leagueId, season: currentSeason)
        }
    }
    
    public func getMockLeaders(for leagueId: Int, using filterValue: LeaderFilterType) -> [Leader] {
        return JSONLoader.loadJSONData(from: "leaders-\(filterValue.rawValue)-\(leagueId)", decodingType: LeadersResponse.self)?
            .toBlModels(statType: filterValue) ?? [Leader]()
    }
}

// MARK: Private helpers

extension LeadersService {
    
    private func getTopGoals(for leagueId: Int, season: Int) async -> [Leader] {
        let endpoint = LeadersEndpoint.topGoals(leagueId: leagueId, season: season)
        let topGoals = try? (await sendRequest(to: endpoint, expect: LeadersResponse.self)).get()
        
        return topGoals?.toBlModels(statType: .goals) ?? [Leader]()
    }
    
    private func getTopAssists(for leagueId: Int, season: Int) async -> [Leader] {
        let endpoint = LeadersEndpoint.topAssists(leagueId: leagueId, season: season)
        let topAssists = try? (await sendRequest(to: endpoint, expect: LeadersResponse.self)).get()
        
        return topAssists?.toBlModels(statType: .assists) ?? [Leader]()
    }
    
    private func getTopYellowCards(for leagueId: Int, season: Int) async -> [Leader] {
        let endpoint = LeadersEndpoint.topYellowCards(leagueId: leagueId, season: season)
        let topYellowCards = try? (await sendRequest(to: endpoint, expect: LeadersResponse.self)).get()
        
        return topYellowCards?.toBlModels(statType: .yellowCards) ?? [Leader]()
    }
    
    private func getTopRedCards(for leagueId: Int, season: Int) async -> [Leader] {
        let endpoint = LeadersEndpoint.topRedCards(leagueId: leagueId, season: season)
        let topRedCards = try? (await sendRequest(to: endpoint, expect: LeadersResponse.self)).get()
        
        return topRedCards?.toBlModels(statType: .redCards) ?? [Leader]()
    }
}
