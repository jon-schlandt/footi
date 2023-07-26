//
//  Fixture.swift
//  Footi
//
//  Created by Jon Schlandt on 6/29/23.
//

import Foundation

struct Fixture {
    var matchday: String
    var date: String
    var status: FixtureStatus
    var homeSide: MatchupSide
    var awaySide: MatchupSide
}

struct FixtureStatus {
    var short: String
    var long: String
    var type: FixtureStatusType?
    var minutesPlayed: Int?
}

struct MatchupSide {
    var name: String
    var badge: URL
    var goals: Int?
    var isWinner: Bool?
}

enum FixtureStatusType: String {
    case finished = "FT-AET-PEN"
    case inPlay = "1H-HT-2H-ET-BT-P-INT-LIVE"
    case upcoming = "TBD-NS"
    case unknown
    
    static public func getStatusType(from status: String) -> FixtureStatusType? {
        let finished = FixtureStatusType.finished.rawValue.components(separatedBy: "-")
        if finished.contains(status) {
            return FixtureStatusType.finished
        }
        
        let inPlay = FixtureStatusType.inPlay.rawValue.components(separatedBy: "-")
        if inPlay.contains(status) {
            return FixtureStatusType.inPlay
        }
        
        let upcoming = FixtureStatusType.upcoming.rawValue.components(separatedBy: "-")
        if upcoming.contains(status) {
            return FixtureStatusType.upcoming
        }
        
        return FixtureStatusType.unknown
    }
}
