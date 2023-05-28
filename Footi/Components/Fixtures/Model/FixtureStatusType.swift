//
//  FixtureStatusType.swift
//  Footi
//
//  Created by Jon Schlandt on 5/16/23.
//

import Foundation

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
