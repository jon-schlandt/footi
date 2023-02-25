//
//  Leagues.swift
//  Footi
//
//  Created by Jon Schlandt on 1/4/23.
//

import Foundation

struct Leagues: Codable {
    let errors: [ApiError]
    let results: Int
    let paging: ApiPaging
    let response: [League]
}

struct League: Codable {
    var overview: LeagueOverview
    var seasons: [Season]
    
    enum CodingKeys: String, CodingKey {
        case overview = "league"
        case seasons
    }
}

struct LeagueOverview: Codable {
    var id: Int
    var name: String
    var type: String
    var logo: String
}

struct Season: Codable {
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
