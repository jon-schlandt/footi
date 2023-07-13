//
//  Standing.swift
//  Footi
//
//  Created by Jon Schlandt on 6/22/23.
//

import Foundation

struct Standing {
    var position: StandingStat
    let clubLogo: URL
    let clubTitle: String
    var matchesPlayed: StandingStat
    var points: StandingStat
    var goalDifference: StandingStat
    var matchesWon: StandingStat
    var matchesDrawn: StandingStat
    var matchesLost: StandingStat
    var goalsScored: StandingStat
    var goalsConceded: StandingStat
    var inPlay: Bool = false
}

struct StandingStat: Equatable, Comparable {
    let value: Int
    var modifier: Int? = nil
    
    var total: Int {
        return value + (modifier ?? 0)
    }
    
    static func ==(lhs: StandingStat, rhs: StandingStat) -> Bool {
        return lhs.total == rhs.total
    }
    
    static func <(lhs: StandingStat, rhs: StandingStat) -> Bool {
        return lhs.total < rhs.total
    }
}
