//
//  LeagueDataFilter.swift
//  Footi
//
//  Created by Jon Schlandt on 5/8/23.
//

import Foundation

struct LeagueDataFilter {
    var title: String
    var options: [DataFilterOption]
}

struct DataFilterOption {
    var displayName: String
    var value: String
    var isEnabled: Bool
}
