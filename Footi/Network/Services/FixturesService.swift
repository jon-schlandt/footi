//
//  FixturesService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/24/23.
//

import Foundation

protocol FixturesServiceable {
    func getFixtures(leagueId: Int, filterType: FixtureFilterType) async -> [Fixture]
}

struct FixturesService: HTTPClient, FixturesServiceable {
    
    private let coreDataContext = CoreDataContext()
    
    // MARK: Public
    
    public func getFixtures(leagueId: Int, filterType: FixtureFilterType) async -> [Fixture] {
        switch filterType {
        case .inPlay:
            return await getFixturesInPlay(for: leagueId)
        case .today:
            return await getFixturesToday(for: leagueId)
        case .upcoming:
            return await getFixturesUpcoming(for: leagueId)
        case .past:
            return await getFixturesPast(for: leagueId)
        }
    }
    
    // MARK: Private
    
    private func getFixturesInPlay(for leagueId: Int) async -> [Fixture] {
        let currentSeason = await coreDataContext.fetchCurrentSeason(for: leagueId)
        guard let currentSeason = currentSeason else {
            return [Fixture]()
        }
        
        let dateToday = Date.getCurrentDateString(as: "yyyy-MM-dd")
        let statusInPlay = "1H-HT-2H-ET-BT-P-INT-LIVE"
        
        return await getFixturesBy(leagueId: leagueId, season: currentSeason, from: dateToday, to: dateToday, status: statusInPlay)
    }
    
    private func getFixturesToday(for leagueId: Int) async -> [Fixture] {
        let currentSeason = await coreDataContext.fetchCurrentSeason(for: leagueId)
        guard let currentSeason = currentSeason else {
            return [Fixture]()
        }

        let dateToday = Date.getCurrentDateString(as: "yyyy-MM-dd")
        return await getFixturesBy(leagueId: leagueId, season: currentSeason, from: dateToday, to: dateToday)
    }
    
    private func getFixturesUpcoming(for leagueId: Int) async -> [Fixture] {
        let currentSeason = await coreDataContext.fetchCurrentSeason(for: leagueId)
        guard let currentSeason = currentSeason else {
            return [Fixture]()
        }
        
        let dateTomorrow = Date.getDateStringTomorrow(as: "yyyy-MM-dd")
        
        let seasonEndDate = await coreDataContext.fetchSeasonEndDate(leagueId: leagueId, season: currentSeason)
        if let seasonEndDate = seasonEndDate {
            return await getFixturesBy(leagueId: leagueId, season: currentSeason, from: dateTomorrow, to: seasonEndDate)
        }
        
        return [Fixture]()
    }
    
    private func getFixturesPast(for leagueId: Int) async -> [Fixture] {
        let currentSeason = await coreDataContext.fetchCurrentSeason(for: leagueId)
        guard let currentSeason = currentSeason else {
            return [Fixture]()
        }
        
        let dateYesterday = Date.getDateStringYesterday(as: "yyyy-MM-dd")
        
        let seasonStartDate = await coreDataContext.fetchSeasonStartDate(leagueId: leagueId, season: currentSeason)
        if let seasonStartDate = seasonStartDate {
            return await getFixturesBy(leagueId: leagueId, season: currentSeason, from: seasonStartDate, to: dateYesterday)
        }
        
        return [Fixture]()
    }
    
    private func getFixturesBy(leagueId: Int, season: Int, from: String, to: String) async -> [Fixture] {
        let endpoint = FixturesEndpoint.byDateRange(leagueId: leagueId, season: season, from: from, to: to)
        
        let fixtures = try? (await sendRequest(to: endpoint, expect: FixturesResponse.self)).get().response
        if let fixtures = fixtures {
            return fixtures
        }
        
        return [Fixture]()
    }
    
    private func getFixturesBy(leagueId: Int, season: Int, from: String, to: String, status: String) async -> [Fixture] {
        let endpoint = FixturesEndpoint.byDateRangeAndStatus(leagueId: leagueId, season: season, from: from, to: to, status: status)
        
        let fixtures = try? (await sendRequest(to: endpoint, expect: FixturesResponse.self)).get().response
        if let fixtures = fixtures {
            return fixtures
        }
        
        return [Fixture]()
    }
}
