//
//  SettingsViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/28/23.
//

import UIKit

struct SettingGroup {
    let key: String
    let title: String
    var options: [SettingOption]
}

struct SettingOption {
    let key: String
    let title: String
    var selections: [SettingSelection]
}

struct SettingSelection {
    let key: String
    let title: String
    var isEnabled: Bool?
}

class SettingsViewController: UITableViewController {
    
    var groups = [SettingGroup]()
    var userDefaultsContext = UserDefaultsContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        self.navigationItem.backButtonTitle = ""
        
        self.tableView.register(SettingGroupHeader.self, forHeaderFooterViewReuseIdentifier: SettingGroupHeader.identifier)
        self.tableView.register(SettingOptionCell.self, forCellReuseIdentifier: SettingOptionCell.identifier)
        
        setSettingGroups()
        styleView()
    }

    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].options.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingGroupHeader.identifier) as! SettingGroupHeader
        let group = groups[section]
        
        header.configure(with: group)
        header.style(for: section)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingOptionCell.identifier, for: indexPath) as! SettingOptionCell
        let group = groups[indexPath.section]
        let option = group.options[indexPath.row]

        cell.configure(with: option)
        cell.style()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groups[indexPath.section]
        let option = group.options[indexPath.row]
        
        let settingsOptionVC = SettingOptionViewController(group: group, option: option)
        self.navigationController?.pushViewController(settingsOptionVC, animated: true)
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
}

/// Private methods
extension SettingsViewController {
    
    private func setSettingGroups() {
        groups.append(getLeagueOptions())
        groups.append(getDisplayOptions())
    }
    
    private func getLeagueOptions() -> SettingGroup {
        var leagueOptions = SettingGroup(key: "leagueOptions", title: "League Options", options: [SettingOption]())
        
        var defaultLeague = SettingOption(key: "defaultLeague", title: "Default League", selections: [SettingSelection]())
        defaultLeague.selections.append(SettingSelection(key: "bundesliga", title: "Bundesliga"))
        defaultLeague.selections.append(SettingSelection(key: "laLiga", title: "LaLiga"))
        defaultLeague.selections.append(SettingSelection(key: "ligue1", title: "Ligue 1"))
        defaultLeague.selections.append(SettingSelection(key: "mls", title: "Major League Soccer"))
        defaultLeague.selections.append(SettingSelection(key: "premierLeague", title: "Premier League"))
        defaultLeague.selections.append(SettingSelection(key: "serieA", title: "Serie A"))
        
        leagueOptions.options.append(defaultLeague)
        return leagueOptions
    }
    
    private func getDisplayOptions() -> SettingGroup {
        var displayOptions = SettingGroup(key: "displayOptions", title: "Display Options", options: [SettingOption]())
        
        var theme = SettingOption(key: "theme", title: "Theme", selections: [SettingSelection]())
        theme.selections.append(SettingSelection(key: "system", title: "System"))
        theme.selections.append(SettingSelection(key: "light", title: "Light"))
        theme.selections.append(SettingSelection(key: "dark", title: "Dark"))
        
        var locale = SettingOption(key: "locale", title: "Locale", selections: [SettingSelection]())
        locale.selections.append(SettingSelection(key: "system", title: "System"))

        displayOptions.options.append(theme)
        displayOptions.options.append(locale)
        return displayOptions
    }
    
    private func styleView() {
        self.tableView.separatorStyle = .none
        self.tableView.sectionHeaderTopPadding = 0
        self.view.backgroundColor = UIColor.Palette.background
    }
}
