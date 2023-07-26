//
//  League.swift
//  Footi
//
//  Created by Jon Schlandt on 7/25/23.
//

import Foundation

struct League {
    var id: Int
    var name: String
    var logo: URL
    var seasons: [Season]
}

struct Season {
    var year: Int
    var startDate: String
    var endDate: String
    var isCurrent: Bool
}
