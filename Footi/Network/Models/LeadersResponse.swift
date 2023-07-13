//
//  LeadersResponse.swift
//  Footi
//
//  Created by Jon Schlandt on 2/22/23.
//

import Foundation

struct LeadersResponse: Codable {
    let errors: [ApiError]
    let results: Int
    let paging: ApiPaging
    let response: [LeaderResponse]
    
    public func toBlModels(statType: LeaderFilterType) -> [Leader] {
        return response.map { rm in
            var stat: Int
            
            switch statType {
            case .goals:
                stat = rm.stats.first?.goals.scored ?? 0
            case .assists:
                stat = rm.stats.first?.goals.assisted ?? 0
            case .yellowCards:
                stat = rm.stats.first?.cards.yellow ?? 0
            case .redCards:
                stat = rm.stats.first?.cards.red ?? 0
            }
            
            let blModel = Leader(
                position: nil,
                image: URL(string: rm.overview.image)!,
                club: rm.stats.first?.club.name ?? "Unknown",
                displayName: rm.overview.displayName,
                firstName: rm.overview.firstName,
                lastName: rm.overview.lastName,
                statType: statType,
                statValue: stat
            )
            
            return blModel
        }
    }
}

struct LeaderResponse: Codable {
    var overview: LeaderOverviewResponse
    var stats: [LeaderStatsResponse]
    
    enum CodingKeys: String, CodingKey {
        case overview = "player"
        case stats = "statistics"
    }
}

struct LeaderOverviewResponse: Codable {
    var id: Int
    var position: Int?
    var displayName: String
    var firstName: String
    var lastName: String
    var image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "name"
        case firstName = "firstname"
        case lastName = "lastname"
        case image = "photo"
    }
}

struct LeaderStatsResponse: Codable {
    var club: Club
    var goals: LeaderGoalsResponse
    var cards: LeaderCardsResponse
    
    enum CodingKeys: String, CodingKey {
        case club = "team"
        case goals
        case cards
    }
}

struct LeaderGoalsResponse: Codable {
    var scored: Int?
    var assisted: Int?
    
    enum CodingKeys: String, CodingKey {
        case scored = "total"
        case assisted = "assists"
    }
}

struct LeaderCardsResponse: Codable {
    var yellow: Int?
    var red: Int?
}
