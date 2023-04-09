//
//  SettingsOptionViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 4/3/23.
//

import UIKit


/// UITableViewController methods
class SettingOptionViewController: UITableViewController {
    
    var group: SettingGroup!
    var option: SettingOption!
    var selections: [SettingSelection]!
    
    let userDefaultsContext = UserDefaultsContext()
    
    init(group: SettingGroup, option: SettingOption) {
        super.init(style: .plain)
    
        self.group = group
        self.option = option
        self.selections = option.selections
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = option.title
        self.tableView.register(SettingSelectionCell.self, forCellReuseIdentifier: SettingSelectionCell.identifier)
        
        setSelections(groupKey: group.key, optionKey: option.key)
        styleView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingSelectionCell.identifier, for: indexPath) as! SettingSelectionCell
        let selection = selections[indexPath.row]
        
        cell.configure(with: selection)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SettingSelectionCell
        if cell.isEnabled {
            return
        }

        userDefaultsContext.setEnabledSelection(groupKey: group.key, optionKey: option.key, selectionKey: cell.key)
        setSelections(groupKey: group.key, optionKey: option.key)

        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

/// Private methods
extension SettingOptionViewController {
    
    private func setSelections(groupKey: String, optionKey: String) {
        let enabledSelection = userDefaultsContext.getEnabledSelection(groupKey: groupKey, optionKey: optionKey)
        
        self.selections = self.selections.map { selection in
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
        self.view.backgroundColor = UIColor.Palette.background
    }
}
