//
//  StandingsViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/12/23.
//

import UIKit

protocol StandingsScrollViewDelegate: AnyObject {
    func setScroll(originatingView: UIScrollView, offset: CGPoint)
}

class StandingsViewController: BaseViewContoller {
    
    // MARK: View
    
    let standingsTableVC: UITableViewController = {
        let vc = UITableViewController()
        vc.tableView.register(StandingsTableHeader.self, forHeaderFooterViewReuseIdentifier: StandingsTableHeader.identifier)
        vc.tableView.register(StandingsTableCell.self, forCellReuseIdentifier: StandingsTableCell.identifier)
        vc.tableView.separatorStyle = .none
        vc.tableView.sectionHeaderTopPadding = 0
        vc.tableView.backgroundColor = .clear
        
        return vc
    }()
    
    var scrollViews = [UIScrollView]()
    
    // MARK: Model

    var standings = [Standing]()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let standingsTable = standingsTableVC.tableView!
        self.baseStackView.addArrangedSubview(standingsTable)
        
        NSLayoutConstraint.activate([
            standingsTable.trailingAnchor.constraint(equalTo: self.baseStackView.trailingAnchor),
            standingsTable.bottomAnchor.constraint(equalTo: self.baseStackView.bottomAnchor),
            standingsTable.leadingAnchor.constraint(equalTo: self.baseStackView.leadingAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Standings"
        self.addChild(standingsTableVC)
        
        standingsTableVC.tableView.dataSource = self
        standingsTableVC.tableView.delegate = self
        
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
                
                standingsTableVC.tableView.reloadData()
            }
        }
    }
    
    override func loadLeagueHeaderDetails() async {
        await super.loadLeagueHeaderDetails()
        
        let seasons = await coreDataContext.fetchSeasons(for: self.selectedLeague.id)
        guard let seasons = seasons else {
            return
        }

        var filterOptions = [DataFilterOption]()
        seasons.sorted { $0 > $1 }.enumerated().forEach { index, season in
            let startYear = String(season)
            let endYear = String(season + 1)

            let displayName = "\(startYear)/\(endYear.suffix(2))"
            let value = season
            let isEnabled = index == 0 ? true : false

            filterOptions.append(DataFilterOption(displayName: displayName, value: String(value), isEnabled: isEnabled))
        }
        
        self.leagueHeaderDetails.filter = LeagueDataFilter(title: nil, options: filterOptions)
        self.leagueHeader.configure(with: self.leagueHeaderDetails)
    }
    
    override func loadModel() async {
        guard let filterOption = self.getEnabledFilterOption(),
              let filterValue = Int(filterOption.value) else {
            return
        }
        
        initializeModel()
        
        standings = getMockStandings(for: self.leagueHeaderDetails.leagueId, season: filterValue)
//        standings = await standingsService.getStandingsBy(leagueId: self.leagueHeaderDetails.leagueId, season: filterValue)
        standingsTableVC.tableView.reloadData()
    }
}

extension StandingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return standings.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: StandingsTableHeader.identifier) as! StandingsTableHeader
        header.scrollDelegate = self
        
        scrollViews.append(header.statTitleView)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StandingsTableCell.identifier, for: indexPath) as! StandingsTableCell
        let standing = standings[indexPath.row]
        
        scrollViews.append(cell.statsView)
        
        cell.configure(with: standing)
        cell.scrollDelegate = self
        
        return cell
    }
}

extension StandingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppConstants.baseCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstants.baseCellHeight
    }
}

extension StandingsViewController: StandingsScrollViewDelegate {
    
    internal func setScroll(originatingView: UIScrollView, offset: CGPoint) {
        scrollViews.forEach { view in
            if view != originatingView {
                view.contentOffset = offset
            }
        }
    }
}

/// Private methods
extension StandingsViewController {
    
    private func initializeModel() {
        if !standings.isEmpty {
            standings.removeAll()
        }
    }
    
    // MARK: Mock Data
    
    private func getMockStandings(for leagueId: Int, season: Int) -> [Standing] {
        return JSONLoader.loadJSONData(from: "standings-\(leagueId)-\(season)", decodingType: StandingsResponse.self)?
            .response.first?["league"]?.standings.first ?? [Standing]()
    }
}
