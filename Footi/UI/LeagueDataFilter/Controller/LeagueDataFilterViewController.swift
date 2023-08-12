//
//  LeagueDataFilterViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 4/16/23.
//

import UIKit

protocol LeagueDataFilterDelegate: AnyObject {
    func setFilter(to filter: LeagueDataFilter)
    func dismissFilter()
}

class LeagueDataFilterViewController: UITableViewController {

    // MARK: Model
    
    private var filter: LeagueDataFilter!
    public weak var delegate: LeagueDataFilterDelegate?
    
    // MARK: Lifecycle
    
    init(filter: LeagueDataFilter) {
        super.init(style: .plain)
        self.filter = filter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = filter.title
        self.tableView.register(LeagueDataFilterTableCell.self, forCellReuseIdentifier: LeagueDataFilterTableCell.identifier)
        
        setupNavigation()
        styleView()
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filter.options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeagueDataFilterTableCell.identifier, for: indexPath) as! LeagueDataFilterTableCell
        let filterOption = filter.options[indexPath.row]
        let isLast = indexPath.row == filter.options.count - 1
        
        cell.configure(with: filterOption, isLast: isLast)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstants.baseCellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LeagueDataFilterTableCell
        if cell.isEnabled {
            return
        }
        
        filter.options = filter.options.map { option in
            var option = option
            
            if option.value == cell.value {
                option.isEnabled = true
                return option
            }
            
            option.isEnabled = false
            return option
        }

        tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.delegate?.setFilter(to: self.filter)
        }
    }
}

// MARK: Private helpers

extension LeagueDataFilterViewController {
    
    private func setupNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18.0, weight: .light, scale: .medium)),
            style: .plain,
            target: self,
            action: #selector(dismissFilter)
        )
    }
    
    private func styleView() {
        self.tableView.separatorStyle = .none
        self.tableView.sectionHeaderTopPadding = 0
        
        self.view.backgroundColor = UIColor.Palette.primaryBackground
    }
    
    @objc private func dismissFilter() {
        delegate?.dismissFilter()
    }
}
