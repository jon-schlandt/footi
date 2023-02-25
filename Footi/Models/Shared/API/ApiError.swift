//
//  ApiError.swift
//  Footi
//
//  Created by Jon Schlandt on 1/5/23.
//

import Foundation

struct ApiError: Codable {
    var time: Date
    var bug: String
    var report: String
}
