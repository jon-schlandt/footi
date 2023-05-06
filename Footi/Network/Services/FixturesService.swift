//
//  FixturesService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/24/23.
//

import Foundation

protocol FixturesServiceable {
    func getFixturesForToday(for leagueId: Int) async -> [Fixture]?
    func getFixturesInPlay(for leagueId: Int) async -> [Fixture]?
    func getUpcomingFixtures(for leagueId: Int) async -> [Fixture]?
    func getPastResults(for leagueId: Int) async -> [Fixture]?
    func getFixturesBy(leagueId: Int, season: Int, from: String, to: String) async -> [Fixture]?
    func getFixturesBy(leagueId: Int, season: Int, from: String, to: String, status: String) async -> [Fixture]?
}

struct FixturesService: HTTPClient, FixturesServiceable {
    
    private let coreDataContext = CoreDataContext()
    
    func getFixturesForToday(for leagueId: Int) async -> [Fixture]? {
        let currentSeason = await coreDataContext.fetchCurrentSeason(for: leagueId)
        guard let currentSeason = currentSeason else {
            return nil
        }
        
        let dateToday = Date.getCurrentDate(as: "yyyy-MM-dd")
        return await getFixturesBy(leagueId: leagueId, season: currentSeason, from: dateToday, to: dateToday)
    }
    
    func getFixturesInPlay(for leagueId: Int) async -> [Fixture]? {
        let currentSeason = await coreDataContext.fetchCurrentSeason(for: leagueId)
        guard let currentSeason = currentSeason else {
            return nil
        }
        
        let dateToday = Date.getCurrentDate(as: "yyyy-MM-dd")
        let statusInPlay = "1H-HT-2H-ET-BT-P-INT-LIVE"
        
        return await getFixturesBy(leagueId: leagueId, season: currentSeason, from: dateToday, to: dateToday, status: statusInPlay)
    }
    
    func getUpcomingFixtures(for leagueId: Int) async -> [Fixture]? {
        let currentSeason = await coreDataContext.fetchCurrentSeason(for: leagueId)
        guard let currentSeason = currentSeason else {
            return nil
        }
        
        let dateTomorrow = Date.getDateTomorrow(as: "yyyy-MM-dd")
        
        let seasonEndDate = await coreDataContext.fetchSeasonEndDate(leagueId: leagueId, season: currentSeason)
        if let seasonEndDate = seasonEndDate {
            return await getFixturesBy(leagueId: leagueId, season: currentSeason, from: dateTomorrow, to: seasonEndDate)
        }
        
        return nil
    }
    
    func getPastResults(for leagueId: Int) async -> [Fixture]? {
        let currentSeason = await coreDataContext.fetchCurrentSeason(for: leagueId)
        guard let currentSeason = currentSeason else {
            return nil
        }
        
        let dateYesterday = Date.getDateYesterday(as: "yyyy-MM-dd")
        
        let seasonStartDate = await coreDataContext.fetchSeasonStartDate(leagueId: leagueId, season: currentSeason)
        if let seasonStartDate = seasonStartDate {
            return await getFixturesBy(leagueId: leagueId, season: currentSeason, from: dateYesterday, to: seasonStartDate)
        }
        
        return nil
    }
    
    func getFixturesBy(leagueId: Int, season: Int, from: String, to: String) async -> [Fixture]? {
        let endpoint = FixturesEndpoint.byDateRange(leagueId: leagueId, season: season, from: from, to: to)
        let fixtures = try? (await sendRequest(to: endpoint, expect: Fixtures.self)).get().response
        
        return fixtures
    }
    
    func getFixturesBy(leagueId: Int, season: Int, from: String, to: String, status: String) async -> [Fixture]? {
        let endpoint = FixturesEndpoint.byDateRangeAndStatus(leagueId: leagueId, season: season, from: from, to: to, status: status)
        let fixtures = try? (await sendRequest(to: endpoint, expect: Fixtures.self)).get().response
        
        return fixtures
    }
}
