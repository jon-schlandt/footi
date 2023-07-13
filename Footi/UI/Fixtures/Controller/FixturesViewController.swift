//
//  FixturesViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/12/23.
//

import UIKit

class FixturesViewController: BaseViewContoller {
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        self.baseTableVC = FixturesTableViewController()
        self.baseStackView.addArrangedSubview(self.baseTableVC.tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle(as: "Fixtures")
        
        _Concurrency.Task {
            await loadLeagueHeaderDetails()
            await loadModel()
            
            self.baseTableVC.hasLoaded = true
        }
    }
    
    // MARK: Base overrides
    
    override func loadLeagueHeaderDetails() async {
        await super.loadLeagueHeaderDetails()
        
        self.leagueHeaderDetails.isLive = await setIsLive()
        self.leagueHeaderDetails.filter = setDataFilter()
        self.leagueHeader.configure(with: self.leagueHeaderDetails)
    }
    
    override func reloadLeagueHeaderDetails() async {
        await super.reloadLeagueHeaderDetails()
        
        guard let filterOption = self.getEnabledFilterOption(),
              let filterValue = FixtureFilterType(rawValue: filterOption.value) else {
            return
        }
        
        let isToday = filterValue == .today
        if isToday {
            self.leagueHeaderDetails.isLive = await setIsLive()
        } else {
            self.leagueHeaderDetails.isLive = false
        }

        self.leagueHeader.configure(with: self.leagueHeaderDetails)
    }
    
    override func loadModel() async {
        await super.loadModel()
        
        guard let filterOption = self.getEnabledFilterOption(),
              let filterValue = FixtureFilterType(rawValue: filterOption.value) else {
            return
        }
        
        #if DEBUG
        var fixtures = fixturesService.getMockFixtures(for: self.leagueHeaderDetails.leagueId, using: filterValue)
        #else
        var fixtures = await fixturesService.getFixtures(leagueId: self.leagueHeaderDetails.leagueId, filterType: filterValue)
        #endif
        
        if (filterValue == .past) {
            fixtures.sort { $0.overview.date > $1.overview.date }
        } else {
            fixtures.sort { $0.overview.date < $1.overview.date }
        }
        
        self.baseTableVC.model = fixtures
        self.baseTableVC.tableView.reloadData()
    }
}

// MARK: Private helpers

extension FixturesViewController {
    
    private func setIsLive() async -> Bool {
        #if DEBUG
        return !fixturesService.getMockFixturesInPlay(for: self.leagueHeaderDetails.leagueId).isEmpty
        #else
        return await !fixturesService.getFixtures(leagueId: self.leagueHeaderDetails.leagueId, filterType: .inPlay).isEmpty
        #endif
    }
    
    private func setDataFilter() -> LeagueDataFilter {
        var filterOptions = [DataFilterOption]()
        filterOptions.append(DataFilterOption(displayName: "Today", value: FixtureFilterType.today.rawValue, isEnabled: true))
        filterOptions.append(DataFilterOption(displayName: "Upcoming", value: FixtureFilterType.upcoming.rawValue, isEnabled: false))
        filterOptions.append(DataFilterOption(displayName: "Past", value: FixtureFilterType.past.rawValue, isEnabled: false))
        
        return LeagueDataFilter(title: "By date", options: filterOptions)
    }
}
