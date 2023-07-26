//
//  LeadersViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/12/23.
//

import UIKit

class LeadersViewController: BaseViewContoller {

    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        self.baseTableVC = LeadersTableViewController()
        self.baseStackView.addArrangedSubview(self.baseTableVC.tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "Leaders", icon: "medal.fill")
    }
    
    // MARK: Base overrides
    
    override func loadLeagueHeaderDetails() async {
        await super.loadLeagueHeaderDetails()
        
        self.leagueHeaderDetails.filter = setDataFilter()
        self.leagueHeader.configure(with: self.leagueHeaderDetails)
    }
    
    override func loadModel() async {
        await super.loadModel()
        
        guard let filterOption = self.getEnabledFilterOption(),
              let filterValue = LeaderFilterType(rawValue: filterOption.value) else {
            return
        }
        
        #if DEBUG
        self.baseTableVC.model = leadersService.getMockLeaders(for: self.leagueHeaderDetails.leagueId, using: filterValue)
        #else
        self.baseTableVC.model = await leadersService.getLeaders(leagueId: self.leagueHeaderDetails.leagueId, filterType: filterValue)
        #endif
        
        loadPositions()
        baseTableVC.tableView.reloadData()
    }
}

// MARK: Private helpers

extension LeadersViewController {
    
    private func setDataFilter() -> LeagueDataFilter {
        var filterOptions = [DataFilterOption]()
        filterOptions.append(DataFilterOption(displayName: "Goals", value: LeaderFilterType.goals.rawValue, isEnabled: true))
        filterOptions.append(DataFilterOption(displayName: "Assists", value: LeaderFilterType.assists.rawValue, isEnabled: false))
        filterOptions.append(DataFilterOption(displayName: "Yellow Cards", value: LeaderFilterType.yellowCards.rawValue, isEnabled: false))
        filterOptions.append(DataFilterOption(displayName: "Red Cards", value: LeaderFilterType.redCards.rawValue, isEnabled: false))
        
        return LeagueDataFilter(title: "By category", options: filterOptions)
    }
    
    private func loadPositions() {
        var leaders = self.baseTableVC.model as! [Leader]
        
        var currentPosition = 1
        var currentStatValue = 0
        
        leaders = leaders.enumerated().map { index, leader in
            var leader = leader
            
            if index == 0 {
                currentStatValue = leader.statValue
                
                leader.position = currentPosition
                return leader
            }
            
            if leader.statValue == currentStatValue {
                leader.position = currentPosition
                return leader
            }
            
            currentPosition += 1
            currentStatValue = leader.statValue
            
            leader.position = currentPosition
            return leader
        }
        
        self.baseTableVC.model = leaders
    }
}
