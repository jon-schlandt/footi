//
//  LeagueHeaderDetails.swift
//  Footi
//
//  Created by Jon Schlandt on 5/4/23.
//

import Foundation

struct LeagueHeaderDetails {
    var leagueId: Int
    var leagueTitle: String
    var filter: LeagueDataFilter
}

struct LeagueDataFilter {
    var title: String
    var options: [DataFilterOption]
}

struct DataFilterOption {
    var displayName: String
    var value: Int
    var isEnabled: Bool
}
