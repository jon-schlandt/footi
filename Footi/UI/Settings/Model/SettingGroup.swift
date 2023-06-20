//
//  SettingGroup.swift
//  Footi
//
//  Created by Jon Schlandt on 6/13/23.
//

import Foundation

struct SettingGroup: Equatable {
    let key: String
    let title: String
    var options: [SettingOption]
}

struct SettingOption: Equatable {
    let key: String
    let title: String
    var selections: [SettingSelection]
}

struct SettingSelection: Equatable {
    let key: String
    let title: String
    var isEnabled: Bool?
}
