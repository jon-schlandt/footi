//
//  UserDefaultsHelper.swift
//  Footi
//
//  Created by Jon Schlandt on 3/1/23.
//

import Foundation

struct UserDefaultsContext {
    
    let userDefaults = UserDefaults()
    
    func getLeagues() -> [String: [String: Any]]? {
        let leagueMap = userDefaults.object(forKey: "leagues") as? [String: [String: Any]]
        if let leagueMap = leagueMap {
            return leagueMap
        }
        
        return nil
    }
    
    func getSelectedLeague() -> [String: Any]? {
        let leagueMap = userDefaults.object(forKey: "leagues") as? [String: [String: Any]]
        guard let leagueMap = leagueMap else {
            return nil
        }
        
        let selectedLeague = leagueMap.keys.first { league in
            let isSelected = leagueMap[league]?["isSelected"] as? Bool
            return isSelected ?? false
        }
        
        if let selectedLeague = selectedLeague {
            return leagueMap[selectedLeague]
        }
        
        return nil
    }
    
    func setSelectedLeague(as league: String) {
        let leagueMap = UserDefaults().object(forKey: "leagues") as? [String: [String: Any]]
        guard var leagueMap = leagueMap else {
            return
        }

        leagueMap.keys.forEach { league in leagueMap[league]?["isSelected"] = false }
        leagueMap[league]?["isSelected"] = true

        UserDefaults().set(leagueMap, forKey: "leagues")
    }
    
    func getUserSetting(for setting: String) -> String? {
        let settings = UserDefaults().object(forKey: "settings") as? [String: [String: Any]]
        guard let settings = settings else {
            return nil
        }
        
        let options = settings[setting] as? [String: Bool]
        guard let options = options else {
            return nil
        }
        
        let enabledOption = options.keys.first { options[$0] == true }
        return enabledOption
    }
    
    func setUserSetting(setting: String, option: String) {
        let settings = UserDefaults().object(forKey: "settings") as? [String: [String: Any]]
        guard var settings = settings else {
            return
        }

        let options = settings[setting] as? [String: Bool]
        guard var options = options else {
            return
        }

        options.keys.forEach { options[$0] = false }
        options[option] = true
        settings[setting] = options

        UserDefaults().set(settings, forKey: "settings")
    }
}
