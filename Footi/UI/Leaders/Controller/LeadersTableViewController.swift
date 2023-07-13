//
//  LeadersTableViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 7/8/23.
//

import UIKit

class LeadersTableViewController: BaseTableViewController {

    // MARK: Model
    
    private var leaders: [Leader] {
        if self.model is [Leader] {
            return self.model as! [Leader]
        }
        
        return [Leader]()
    }
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        self.tableView.register(LeadersTableHeader.self, forHeaderFooterViewReuseIdentifier: LeadersTableHeader.identifier)
        self.tableView.register(LeadersTableCell.self, forCellReuseIdentifier: LeadersTableCell.identifier)
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaders.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: LeadersTableHeader.identifier) as! LeadersTableHeader
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if leaders.isEmpty {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LeadersTableCell.identifier, for: indexPath) as! LeadersTableCell
        let leader = leaders[indexPath.row]
        let isLast = indexPath.row == leaders.count - 1
        
        cell.configure(with: leader, isLast: isLast)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppConstants.baseCellHeight + AppConstants.baseSectionSpacing
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstants.baseCellHeight + 20
    }
}
