//
//  Leagues.swift
//  Footi
//
//  Created by Jon Schlandt on 1/4/23.
//

import Foundation

struct LeaguesResponse: Codable {
    let errors: [ApiError]
    let results: Int
    let paging: ApiPaging
    let response: [LeagueResponse]
    
    public func toBlModels() -> [League] {
        return response.map { rm in
            let seasons = rm.seasons.map { season in
                return Season(
                    year: season.year,
                    startDate: season.startDate,
                    endDate: season.endDate,
                    isCurrent: season.isCurrent
                )
            }
            
            return League(
                id: rm.overview.id,
                name: rm.overview.name,
                logo: URL(string: rm.overview.logo)!,
                seasons: seasons
            )
        }
    }
}

struct LeagueResponse: Codable {
    var overview: LeagueOverviewResponse
    var seasons: [SeasonResponse]
    
    enum CodingKeys: String, CodingKey {
        case overview = "league"
        case seasons
    }
}

struct LeagueOverviewResponse: Codable {
    var id: Int
    var name: String
    var type: String
    var logo: String
}

struct SeasonResponse: Codable {
    var year: Int
    var startDate: String
    var endDate: String
    var isCurrent: Bool

    enum CodingKeys: String, CodingKey {
        case year
        case startDate = "start"
        case endDate = "end"
        case isCurrent = "current"
    }
}
