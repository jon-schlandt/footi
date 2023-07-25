//
//  UserDefaultsHelper.swift
//  Footi
//
//  Created by Jon Schlandt on 3/1/23.
//

import Foundation

struct UserDefaultsContext {
    
    let userDefaults = UserDefaults()
    
    // MARK: Public methods
    
    public func getLeagues() -> [String: [String: Any]]? {
        let leagueMap = userDefaults.object(forKey: "leagues") as? [String: [String: Any]]
        if let leagueMap = leagueMap {
            return leagueMap
        }
        
        return nil
    }
    
    public func getSelectedLeague() -> LeagueSelection? {
        let leagueMap = userDefaults.object(forKey: "leagues") as? [String: [String: Any]]
        guard let leagueMap = leagueMap else {
            return nil
        }
        
        let leagueKey = leagueMap.keys.first { league in
            let isSelected = leagueMap[league]?["isSelected"] as? Bool
            return isSelected ?? false
        }
        
        guard let leagueKey = leagueKey else {
            return nil
        }
        
        let selectedLeague = leagueMap[leagueKey]
        guard let selectedLeague = selectedLeague else {
            return nil
        }
        
        let leagueId = selectedLeague["id"] as? Int
        let leagueTitle = selectedLeague["displayName"] as? String
        if let leagueId = leagueId,
           let leagueTitle = leagueTitle {
            return LeagueSelection(id: leagueId, key: leagueKey, title: leagueTitle)
        }
        
        return nil
    }
    
    public func setSelectedLeague(as league: String) {
        let leagueMap = UserDefaults().object(forKey: "leagues") as? [String: [String: Any]]
        guard var leagueMap = leagueMap else {
            return
        }

        leagueMap.keys.forEach { league in leagueMap[league]?["isSelected"] = false }
        leagueMap[league]?["isSelected"] = true

        UserDefaults().set(leagueMap, forKey: "leagues")
    }
    
    public func getEnabledSelection(groupKey: String, optionKey: String) -> String? {
        let settingMap = UserDefaults().object(forKey: "settings") as? [String: Any]
        guard let settingMap = settingMap else {
            return nil
        }
        
        let group = settingMap[groupKey] as? [String: Any]
        guard let group = group else {
            return nil
        }
        
        let option = group[optionKey] as? [String: Bool]
        guard let option = option else {
            return nil
        }
        
        let enabledSelection = option.keys.first { selection in
            return option[selection] == true
        }
        
        return enabledSelection
    }
    
    public func setEnabledSetting(groupKey: String, optionKey: String, selectionKey: String) {
        let settingMap = UserDefaults().object(forKey: "settings") as? [String: Any]
        guard var settingMap = settingMap else {
            return
        }
        
        let group = settingMap[groupKey] as? [String: Any]
        guard var group = group else {
            return
        }
        
        let option = group[optionKey] as? [String: Bool]
        guard var option = option else {
            return
        }
        
        option.keys.forEach { key in
            if key == selectionKey {
                return option[key] = true
            }
            
            return option[key] = false
        }
        
        group[optionKey] = option
        settingMap[groupKey] = group
        
        UserDefaults().set(settingMap, forKey: "settings")
    }
}
