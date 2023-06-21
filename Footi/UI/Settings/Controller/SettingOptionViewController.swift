//
//  SettingsOptionViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 4/3/23.
//

import UIKit

protocol SettingsOptionDelegate: AnyObject {
    func toggleSelection(groupKey: String, optionKey: String, selectionKey: String)
}

/// UITableViewController methods
class SettingOptionViewController: UITableViewController {
    
    let userDefaultsContext = UserDefaultsContext()
    public weak var delegate: SettingsOptionDelegate!
    
    // MARK: Model
    
    public var groupKey: String
    public var option: SettingOption
    
    // MARK: Lifecycle
    
    init(groupKey: String, option: SettingOption) {
        self.groupKey = groupKey
        self.option = option
        
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = option.title
        self.tableView.register(SettingSelectionCell.self, forCellReuseIdentifier: SettingSelectionCell.identifier)
        
        styleView()
    }

    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return option.selections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingSelectionCell.identifier, for: indexPath) as! SettingSelectionCell
        let selection = option.selections[indexPath.row]
        let isLast = indexPath.row == option.selections.count - 1
        
        cell.configure(with: selection, isLast: isLast)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SettingSelectionCell
        guard let selection = cell.selection else {
            return
        }
        
        guard selection.isEnabled == false else {
            return
        }
        
        userDefaultsContext.setEnabledSetting(groupKey: groupKey, optionKey: option.key, selectionKey: selection.key)
        delegate.toggleSelection(groupKey: groupKey, optionKey: option.key, selectionKey: selection.key)
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstants.baseCellHeight
    }
}

/// Private methods
extension SettingOptionViewController {
    
    private func styleView() {
        self.tableView.separatorStyle = .none
        self.tableView.sectionHeaderTopPadding = 0
        self.view.backgroundColor = UIColor.Palette.primaryBackground
    }
}
