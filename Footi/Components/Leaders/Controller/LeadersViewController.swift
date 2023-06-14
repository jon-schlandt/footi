//
//  LeadersViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/12/23.
//

import UIKit

class LeadersViewController: BaseViewContoller {
    
    // MARK: View
    
    let leadersTableVC: UITableViewController = {
        let vc = UITableViewController()
        vc.tableView.register(LeadersTableHeader.self, forHeaderFooterViewReuseIdentifier: LeadersTableHeader.identifier)
        vc.tableView.register(LeadersTableCell.self, forCellReuseIdentifier: LeadersTableCell.identifier)
        vc.tableView.separatorStyle = .none
        vc.tableView.sectionHeaderTopPadding = 0
        vc.tableView.backgroundColor = .clear
        
        return vc
    }()
    
    // MARK: Model
    
    var leaders = [Leader]()

    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let leadersTable = leadersTableVC.tableView!
        self.baseStackView.addArrangedSubview(leadersTable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Leaders"
        self.addChild(leadersTableVC)
        
        leadersTableVC.tableView.dataSource = self
        leadersTableVC.tableView.delegate = self
        
        _Concurrency.Task {
            await loadLeagueHeaderDetails()
            await loadModel()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.hasLeagueChanged()) {
            _Concurrency.Task {
                await self.reloadSelectedLeague()
                await loadLeagueHeaderDetails()
                await loadModel()
            }
        }
    }
    
    override func loadLeagueHeaderDetails() async {
        await super.loadLeagueHeaderDetails()
        
        var filterOptions = [DataFilterOption]()
        filterOptions.append(DataFilterOption(displayName: "Goals", value: LeaderFilterType.goals.rawValue, isEnabled: true))
        filterOptions.append(DataFilterOption(displayName: "Assists", value: LeaderFilterType.assists.rawValue, isEnabled: false))
        filterOptions.append(DataFilterOption(displayName: "Yellow Cards", value: LeaderFilterType.yellowCards.rawValue, isEnabled: false))
        filterOptions.append(DataFilterOption(displayName: "Red Cards", value: LeaderFilterType.redCards.rawValue, isEnabled: false))
        
        self.leagueHeaderDetails.filter = LeagueDataFilter(title: "By Stat", options: filterOptions)
        self.leagueHeader.configure(with: self.leagueHeaderDetails)
    }
    
    override func loadModel() async {
        guard let filterOption = self.getEnabledFilterOption(),
              let filterValue = LeaderFilterType(rawValue: filterOption.value) else {
            return
        }
        
        initializeModel()
        
//        leaders = await leadersService.getLeaders(leagueId: self.leagueHeaderDetails.leagueId, filterType: filterValue)
        leaders = getMockLeaders(for: self.leagueHeaderDetails.leagueId, using: filterValue)
        setPositions()
        
        leadersTableVC.tableView.reloadData()
    }
}

extension LeadersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaders.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: LeadersTableHeader.identifier) as! LeadersTableHeader
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeadersTableCell.identifier, for: indexPath) as! LeadersTableCell
        let leader = leaders[indexPath.row]
        
        guard let filterOption = self.getEnabledFilterOption(),
              let filterValue = LeaderFilterType(rawValue: filterOption.value) else {
            return cell
        }
        
        cell.configure(with: leader, filterType: filterValue)
        return cell
    }
}

extension LeadersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppConstants.baseCellHeight + AppConstants.baseSectionSpacing
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstants.baseCellHeight + 20
    }
}

/// Private methods
extension LeadersViewController {
    
    private func initializeModel() {
        if !leaders.isEmpty {
            leaders.removeAll()
        }
    }
    
    private func setPositions() {
        guard let filterOption = self.getEnabledFilterOption(),
              let filterValue = LeaderFilterType(rawValue: filterOption.value) else {
            return
        }
        
        var currentPosition = 1
        var currentStatValue = 0
        
        leaders = leaders.enumerated().map { index, leader in
            var leader = leader
            var stat: Int
            
            switch filterValue {
            case .goals:
                stat = leader.stats[0].goals.scored ?? 0
            case .assists:
                stat = leader.stats[0].goals.assisted ?? 0
            case .yellowCards:
                stat = leader.stats[0].cards.yellow ?? 0
            case .redCards:
                stat = leader.stats[0].cards.red ?? 0
            }
            
            if index == 0 {
                currentStatValue = stat
                
                leader.overview.position = currentPosition
                return leader
            }
            
            if stat == currentStatValue {
                leader.overview.position = currentPosition
                return leader
            }
            
            currentPosition += 1
            currentStatValue = stat
            
            leader.overview.position = currentPosition
            return leader
        }
    }
    
    // MARK: Mock Data
    
    private func getMockLeaders(for leagueId: Int, using filterValue: LeaderFilterType) -> [Leader] {
        return JSONLoader.loadJSONData(from: "leaders-\(filterValue.rawValue)-\(leagueId)", decodingType: LeadersResponse.self)?
            .response ?? [Leader]()
    }
}
