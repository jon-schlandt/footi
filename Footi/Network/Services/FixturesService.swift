//
//  FixturesService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/24/23.
//

import Foundation

protocol FixturesServiceable {
    func getFixtures(leagueId: Int, filterType: FixtureFilterType) async -> [Fixture]
    func getMockFixtures(for leagueId: Int, using filterValue: FixtureFilterType) -> [Fixture]
    func getMockFixturesInPlay(for leagueId: Int) -> [Fixture]
}

struct FixturesService: HTTPClient, FixturesServiceable {
    
    private let coreDataContext = CoreDataContext()
    
    // MARK: Public methods
    
    public func getFixtures(leagueId: Int, filterType: FixtureFilterType) async -> [Fixture] {
        let currentSeason = await coreDataContext.fetchCurrentSeason(for: leagueId)
        guard let currentSeason = currentSeason else {
            return [Fixture]()
        }
        
        var fixtures: [Fixture]
        
        switch filterType {
        case .inPlay:
            fixtures = await getFixturesInPlay(for: leagueId, season: currentSeason)
        case .today:
            fixtures = await getFixturesToday(for: leagueId, season: currentSeason)
        case .upcoming:
            fixtures = await getFixturesUpcoming(for: leagueId, season: currentSeason)
        case .past:
            fixtures = await getFixturesPast(for: leagueId, season: currentSeason)
        }
        
        return fixtures
    }
    
    public func getMockFixtures(for leagueId: Int, using filterValue: FixtureFilterType) -> [Fixture] {
        let fixtures = JSONLoader.loadJSONData(from: "fixtures-\(filterValue.rawValue)-\(leagueId)", decodingType: FixturesResponse.self)
        guard let fixtures = fixtures else {
            return [Fixture]()
        }
        
        return fixtures.toBlModels()
    }
    
    public func getMockFixturesInPlay(for leagueId: Int) -> [Fixture] {
        let fixtures = JSONLoader.loadJSONData(from: "fixtures-inPlay-\(leagueId)", decodingType: FixturesResponse.self)
        guard let fixtures = fixtures else {
            return [Fixture]()
        }
        
        return fixtures.toBlModels()
    }
}

// MARK: Private helpers

extension FixturesService {
    
    private func getFixturesInPlay(for leagueId: Int, season: Int) async -> [Fixture] {
        let dateToday = Date.getCurrentDateString(as: "yyyy-MM-dd")
        let statusInPlay = "1H-HT-2H-ET-BT-P-INT-LIVE"
        
        return await getFixturesBy(leagueId: leagueId, season: season, from: dateToday, to: dateToday, status: statusInPlay)
    }
    
    private func getFixturesToday(for leagueId: Int, season: Int) async -> [Fixture] {
        let dateToday = Date.getCurrentDateString(as: "yyyy-MM-dd")
        return await getFixturesBy(leagueId: leagueId, season: season, from: dateToday, to: dateToday)
    }
    
    private func getFixturesUpcoming(for leagueId: Int, season: Int) async -> [Fixture] {
        let dateTomorrow = Date.getDateStringTomorrow(as: "yyyy-MM-dd")
        
        let seasonEndDate = await coreDataContext.fetchSeasonEndDate(leagueId: leagueId, season: season)
        if let seasonEndDate = seasonEndDate {
            return await getFixturesBy(leagueId: leagueId, season: season, from: dateTomorrow, to: seasonEndDate)
        }
        
        return [Fixture]()
    }
    
    private func getFixturesPast(for leagueId: Int, season: Int) async -> [Fixture] {
        let dateYesterday = Date.getDateStringYesterday(as: "yyyy-MM-dd")
        
        let seasonStartDate = await coreDataContext.fetchSeasonStartDate(leagueId: leagueId, season: season)
        if let seasonStartDate = seasonStartDate {
            return await getFixturesBy(leagueId: leagueId, season: season, from: seasonStartDate, to: dateYesterday)
        }
        
        return [Fixture]()
    }
    
    private func getFixturesBy(leagueId: Int, season: Int, from: String, to: String) async -> [Fixture] {
        let endpoint = FixturesEndpoint.byDateRange(leagueId: leagueId, season: season, from: from, to: to)
        
        let fixtures = try? (await sendRequest(to: endpoint, expect: FixturesResponse.self)).get()
        if let fixtures = fixtures {
            return fixtures.toBlModels()
        }
        
        return [Fixture]()
    }
    
    private func getFixturesBy(leagueId: Int, season: Int, from: String, to: String, status: String) async -> [Fixture] {
        let endpoint = FixturesEndpoint.byDateRangeAndStatus(leagueId: leagueId, season: season, from: from, to: to, status: status)
        
        let fixtures = try? (await sendRequest(to: endpoint, expect: FixturesResponse.self)).get()
        if let fixtures = fixtures {
            return fixtures.toBlModels()
        }
        
        return [Fixture]()
    }
}
