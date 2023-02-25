//
//  FixturesService.swift
//  Footi
//
//  Created by Jon Schlandt on 2/24/23.
//

import Foundation

protocol FixturesServiceable {
    func getFixturesBy(leagueId: Int, season: Int, from: String, to: String) async -> Result<Fixtures, RequestError>
    func getFixturesBy(leagueId: Int, season: Int, from: String, to: String, status: String) async -> Result<Fixtures, RequestError>
}

struct FixturesService: HTTPClient, FixturesServiceable {
    func getFixturesBy(leagueId: Int, season: Int, from: String, to: String) async -> Result<Fixtures, RequestError> {
        let endpoint = FixturesEndpoint.byDateRange(leagueId: leagueId, season: season, from: from, to: to)
        return await sendRequest(to: endpoint, expect: Fixtures.self)
    }
    
    func getFixturesBy(leagueId: Int, season: Int, from: String, to: String, status: String) async -> Result<Fixtures, RequestError> {
        let endpoint = FixturesEndpoint.byDateRangeAndStatus(leagueId: leagueId, season: season, from: from, to: to, status: status)
        return await sendRequest(to: endpoint, expect: Fixtures.self)
    }
}
