//
//  FixturesService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/24/23.
//

import Foundation

protocol FixturesServiceable {
    func getFixtures(leagueId: Int, filterType: FixtureFilterType) async -> [FixtureResponse]
    func getMockFixtures(for leagueId: Int, using filterValue: FixtureFilterType) -> [FixtureResponse]
    func getMockFixturesInPlay(for leagueId: Int) -> [FixtureResponse]
}

struct FixturesService: HTTPClient, FixturesServiceable {
    
    private let coreDataContext = CoreDataContext()
    
    // MARK: Public methods
    
    public func getFixtures(leagueId: Int, filterType: FixtureFilterType) async -> [FixtureResponse] {
        let currentSeason = await coreDataContext.fetchCurrentSeason(for: leagueId)
        guard let currentSeason = currentSeason else {
            return [FixtureResponse]()
        }
        
        switch filterType {
        case .inPlay:
            return await getFixturesInPlay(for: leagueId, season: currentSeason)
        case .today:
            return await getFixturesToday(for: leagueId, season: currentSeason)
        case .upcoming:
            return await getFixturesUpcoming(for: leagueId, season: currentSeason)
        case .past:
            return await getFixturesPast(for: leagueId, season: currentSeason)
        }
    }
    
    public func getMockFixtures(for leagueId: Int, using filterValue: FixtureFilterType) -> [FixtureResponse] {
        let fixtures = JSONLoader.loadJSONData(from: "fixtures-\(filterValue.rawValue)-\(leagueId)", decodingType: FixturesResponse.self)?.response
        guard let fixtures = fixtures else {
            return [FixtureResponse]()
        }
        
        return fixtures
    }
    
    public func getMockFixturesInPlay(for leagueId: Int) -> [FixtureResponse] {
        let fixtures = JSONLoader.loadJSONData(from: "fixtures-inPlay-\(leagueId)", decodingType: FixturesResponse.self)?.response
        guard let fixtures = fixtures else {
            return [FixtureResponse]()
        }
        
        return fixtures
    }
}

// MARK: Private helpers

extension FixturesService {
    
    private func getFixturesInPlay(for leagueId: Int, season: Int) async -> [FixtureResponse] {
        let dateToday = Date.getCurrentDateString(as: "yyyy-MM-dd")
        let statusInPlay = "1H-HT-2H-ET-BT-P-INT-LIVE"
        
        return await getFixturesBy(leagueId: leagueId, season: season, from: dateToday, to: dateToday, status: statusInPlay)
    }
    
    private func getFixturesToday(for leagueId: Int, season: Int) async -> [FixtureResponse] {
        let dateToday = Date.getCurrentDateString(as: "yyyy-MM-dd")
        return await getFixturesBy(leagueId: leagueId, season: season, from: dateToday, to: dateToday)
    }
    
    private func getFixturesUpcoming(for leagueId: Int, season: Int) async -> [FixtureResponse] {
        let dateTomorrow = Date.getDateStringTomorrow(as: "yyyy-MM-dd")
        
        let seasonEndDate = await coreDataContext.fetchSeasonEndDate(leagueId: leagueId, season: season)
        if let seasonEndDate = seasonEndDate {
            return await getFixturesBy(leagueId: leagueId, season: season, from: dateTomorrow, to: seasonEndDate)
        }
        
        return [FixtureResponse]()
    }
    
    private func getFixturesPast(for leagueId: Int, season: Int) async -> [FixtureResponse] {
        let dateYesterday = Date.getDateStringYesterday(as: "yyyy-MM-dd")
        
        let seasonStartDate = await coreDataContext.fetchSeasonStartDate(leagueId: leagueId, season: season)
        if let seasonStartDate = seasonStartDate {
            return await getFixturesBy(leagueId: leagueId, season: season, from: seasonStartDate, to: dateYesterday)
        }
        
        return [FixtureResponse]()
    }
    
    private func getFixturesBy(leagueId: Int, season: Int, from: String, to: String) async -> [FixtureResponse] {
        let endpoint = FixturesEndpoint.byDateRange(leagueId: leagueId, season: season, from: from, to: to)
        
        let fixtures = try? (await sendRequest(to: endpoint, expect: FixturesResponse.self)).get().response
        if let fixtures = fixtures {
            return fixtures
        }
        
        return [FixtureResponse]()
    }
    
    private func getFixturesBy(leagueId: Int, season: Int, from: String, to: String, status: String) async -> [FixtureResponse] {
        let endpoint = FixturesEndpoint.byDateRangeAndStatus(leagueId: leagueId, season: season, from: from, to: to, status: status)
        
        let fixtures = try? (await sendRequest(to: endpoint, expect: FixturesResponse.self)).get().response
        if let fixtures = fixtures {
            return fixtures
        }
        
        return [FixtureResponse]()
    }
}
