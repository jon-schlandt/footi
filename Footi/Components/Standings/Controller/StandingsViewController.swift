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
    
    // MARK: Controllers and Views
    
    let standingsTableVC: UITableViewController = {
        let vc = UITableViewController()
        vc.tableView.register(StandingsTableHeader.self, forHeaderFooterViewReuseIdentifier: StandingsTableHeader.identifier)
        vc.tableView.register(StandingsTableCell.self, forCellReuseIdentifier: StandingsTableCell.identifier)
        vc.tableView.separatorStyle = .none
        vc.tableView.sectionHeaderTopPadding = 0
        vc.tableView.backgroundColor = .clear
        
        return vc
    }()
    
    var leagueDataFilterMenu: BaseNavigationController!
    let leagueHeader = LeagueHeaderView()
    var scrollViews = [UIScrollView]()
    
    // MARK: Model

    var leagueHeaderDetails: LeagueHeaderDetails!
    var standings = [ClubStanding]()
    
    // MARK: Lifecycle
    
    override func loadView() {
        let rootView = UIView()
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 6
        rootView.addSubview(stackView)
        
        let standingsTable = standingsTableVC.tableView!
        
        stackView.addArrangedSubview(leagueHeader)
        stackView.addArrangedSubview(standingsTable)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            leagueHeader.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            leagueHeader.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            leagueHeader.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        NSLayoutConstraint.activate([
            standingsTable.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            standingsTable.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            standingsTable.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
        ])
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Standings"
        self.addChild(standingsTableVC)
        
        standingsTableVC.tableView.dataSource = self
        standingsTableVC.tableView.delegate = self
        leagueHeader.delegate = self
        
        styleView()
        
        _Concurrency.Task {
            await loadLeagueHeaderDetails()
            await loadModel()
        }
    }
    
    override func loadLeagueHeaderDetails() async {
        let selectedLeague = self.userDefaultsContext.getSelectedLeague()
        guard let selectedLeague = selectedLeague else {
            return
        }
        
        let leagueId = selectedLeague["id"] as? Int
        let leagueTitle = selectedLeague["displayName"] as? String
        guard let leagueId = leagueId,
              let leagueTitle = leagueTitle else {
            return
        }
        
        let seasons = await coreDataContext.fetchSeasons(for: leagueId)
        guard let seasons = seasons else {
            return
        }

        var filterOptions = [DataFilterOption]()
        seasons.sorted { $0 > $1 }.enumerated().forEach { index, season in
            if index > 4 {
                return
            }
            
            let startYear = String(season)
            let endYear = String(season + 1)

            let displayName = "\(startYear)/\(endYear.suffix(2))"
            let value = season
            let isEnabled = index == 0 ? true : false

            filterOptions.append(DataFilterOption(displayName: displayName, value: value, isEnabled: isEnabled))
        }

        leagueHeaderDetails = LeagueHeaderDetails(
            leagueId: leagueId,
            leagueTitle: leagueTitle,
            filter: LeagueDataFilter(
                title: "By Season",
                options: filterOptions
            )
        )

        leagueHeader.configure(with: leagueHeaderDetails)
    }
    
    override func loadModel() async {
        standings.removeAll()
        
        let filterOption = leagueHeaderDetails.filter.options.first { $0.isEnabled }
        guard let filterOption = filterOption else {
            return
        }
        
        await standingsService.getStandingsBy(leagueId: leagueHeaderDetails.leagueId, season: filterOption.value)?.forEach { standing in
            let clubStanding = ClubStanding(
                clubId: standing.club.id,
                clubTitle: standing.club.name,
                clubBadgeUrl: standing.club.logo,
                position: standing.rank,
                matchesPlayed: standing.record.played,
                goalsFor: standing.record.goals.scored,
                goalsAgainst: standing.record.goals.conceded,
                points: standing.points,
                wins: standing.record.won,
                draws: standing.record.drew,
                losses: standing.record.lost,
                goalDeficit: standing.goalDifference
            )

            standings.append(clubStanding)
        }
        
//        for i in 0...19 {
//            standings.append(ClubStanding(
//                clubId: 50,
//                clubTitle: "Manchester City",
//                clubBadgeUrl: "https://media-2.api-sports.io/football/teams/50.png",
//                position: i + 1,
//                matchesPlayed: 30,
//                goalsFor: 20 + i,
//                goalsAgainst: 5 + i,
//                points: 30 + i,
//                wins: 10 + i,
//                draws: 0 + i,
//                losses: 0 + i,
//                goalDeficit: (20 + i) - (5 + i)
//            ))
//        }
        
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
        return 54
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

extension StandingsViewController: LeagueHeaderViewDelegate {
    
    internal func presentFilter() {
        let vc = LeagueDataFilterViewController(filter: leagueHeaderDetails.filter)
        vc.delegate = self
        vc.modalPresentationStyle = .pageSheet
        
        leagueDataFilterMenu = BaseNavigationController(rootViewController: vc)
        
        if let sheet = leagueDataFilterMenu.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        self.present(leagueDataFilterMenu, animated: true)
    }
}

extension StandingsViewController: LeagueDataFilterDelegate {
    
    internal func setFilter(to filter: LeagueDataFilter) {
        leagueHeaderDetails.filter = filter
        leagueHeader.configure(with: leagueHeaderDetails)
        
        dismissFilter()
        
        _Concurrency.Task {
            await loadModel()
        }
    }
    
    internal func dismissFilter() {
        leagueDataFilterMenu.dismiss(animated: true)
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
    
    private func styleView() {
        self.view.backgroundColor = UIColor.Palette.background
    }
}
