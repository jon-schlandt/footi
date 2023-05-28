//
//  LeagueSelection.swift
//  Footi
//
//  Created by Jon Schlandt on 5/7/23.
//

import Foundation

struct LeagueSelection: Equatable {
    var id: Int
    var key: String
    var title: String
    
    static func ==(lhs: LeagueSelection, rhs: LeagueSelection) -> Bool {
        return lhs.id == rhs.id && lhs.key == rhs.key && lhs.title == rhs.title
    }
}
