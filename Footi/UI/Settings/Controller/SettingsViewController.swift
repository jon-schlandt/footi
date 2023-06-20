//
//  SettingsViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/28/23.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var userDefaultsContext = UserDefaultsContext()
    
    // MARK: View
    
    private var settingsOptionVC: SettingOptionViewController!
    
    // MARK: Model
    
    var groups = [SettingGroup]()
    
    // MARK: Lifecycle
    
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
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingOptionCell.identifier, for: indexPath) as! SettingOptionCell
        let group = groups[indexPath.section]
        let option = group.options[indexPath.row]
        let isLast = indexPath.row == group.options.count - 1

        cell.configure(with: option, isLast: isLast)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groups[indexPath.section]
        let option = group.options[indexPath.row]
        
        settingsOptionVC = SettingOptionViewController(groupKey: group.key, option: option)
        settingsOptionVC.delegate = self
        
        self.navigationController?.pushViewController(settingsOptionVC, animated: true)
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppConstants.baseCellHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstants.baseCellHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return AppConstants.baseSectionSpacing
    }
}

extension SettingsViewController: SettingsOptionDelegate {
    
    internal func toggleSelection(groupKey: String, optionKey: String, selectionKey: String) {
        let group = groups.first { $0.key == groupKey }!
        var option = group.options.first { $0.key == optionKey }!
        
        option = updateOption(with: option, under: group)
        settingsOptionVC.option = option
        
        self.tableView.reloadData()
        settingsOptionVC.tableView.reloadData()
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
        
        var defaultLeague = SettingOption(key: "defaultLeague", title: "Default league", selections: [SettingSelection]())
        defaultLeague.selections.append(SettingSelection(key: "bundesliga", title: "Bundesliga"))
        defaultLeague.selections.append(SettingSelection(key: "laLiga", title: "LaLiga"))
        defaultLeague.selections.append(SettingSelection(key: "ligue1", title: "Ligue 1"))
        defaultLeague.selections.append(SettingSelection(key: "mls", title: "Major League Soccer"))
        defaultLeague.selections.append(SettingSelection(key: "premierLeague", title: "Premier League"))
        defaultLeague.selections.append(SettingSelection(key: "serieA", title: "Serie A"))
        defaultLeague.selections = setSelections(for: defaultLeague, under: leagueOptions)
        
        leagueOptions.options.append(defaultLeague)
        return leagueOptions
    }
    
    private func getDisplayOptions() -> SettingGroup {
        var displayOptions = SettingGroup(key: "displayOptions", title: "Display Options", options: [SettingOption]())
        
        var theme = SettingOption(key: "theme", title: "Theme", selections: [SettingSelection]())
        theme.selections.append(SettingSelection(key: "system", title: "System"))
        theme.selections.append(SettingSelection(key: "light", title: "Light"))
        theme.selections.append(SettingSelection(key: "dark", title: "Dark"))
        theme.selections = setSelections(for: theme, under: displayOptions)
        
        var locale = SettingOption(key: "locale", title: "Locale", selections: [SettingSelection]())
        locale.selections.append(SettingSelection(key: "system", title: "System"))
        locale.selections = setSelections(for: locale, under: displayOptions)

        displayOptions.options.append(theme)
        displayOptions.options.append(locale)
        return displayOptions
    }
    
    private func updateOption(with option: SettingOption, under group: SettingGroup) -> SettingOption {
        var option = option, group = group
        
        groups = groups.map { g in
            guard g == group else {
                return g
            }
            
            let optionIndex = group.options.firstIndex { $0 == option }
            guard let optionIndex = optionIndex else {
                return group
            }
            
            option.selections = setSelections(for: option, under: group)
            group.options.replaceSubrange(optionIndex...optionIndex, with: [option])
            
            return group
        }
        
        return option
    }
    
    private func setSelections(for option: SettingOption, under group: SettingGroup) -> [SettingSelection] {
        let enabledSelection = userDefaultsContext.getEnabledSelection(groupKey: group.key, optionKey: option.key)
        
        return option.selections.map { selection in
            var selection = selection
            
            if selection.key == enabledSelection {
                selection.isEnabled = true
            } else {
                selection.isEnabled = false
            }
            
            return selection
        }
    }
    
    private func styleView() {
        self.tableView.separatorStyle = .none
        self.tableView.sectionHeaderTopPadding = 0
        
        self.view.backgroundColor = UIColor.Palette.background
    }
}
