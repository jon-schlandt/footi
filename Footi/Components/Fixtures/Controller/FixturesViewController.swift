//
//  FixturesViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/12/23.
//

import UIKit

class FixturesViewController: BaseViewContoller {
    
    // MARK: Controllers and Views
    
    let fixturesTableVC: UITableViewController = {
        let vc = UITableViewController()
        vc.tableView.register(FixturesTableHeader.self, forHeaderFooterViewReuseIdentifier: FixturesTableHeader.identifier)
        vc.tableView.register(FixturesTableCell.self, forCellReuseIdentifier: FixturesTableCell.identifier)
        vc.tableView.separatorStyle = .none
        vc.tableView.sectionHeaderTopPadding = 0
        vc.tableView.backgroundColor = .clear
        
        return vc
    }()
    
    // MARK: Model
    
    var matchdays = [Int]()
    var fixtureMap = [Int: [Fixture]]()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let rootView = UIView()
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = AppConstants.baseSectionSpacing
        rootView.addSubview(stackView)
        
        let fixturesTable = fixturesTableVC.tableView!
        
        stackView.addArrangedSubview(self.leagueHeader)
        stackView.addArrangedSubview(fixturesTable)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.leagueHeader.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            self.leagueHeader.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            self.leagueHeader.heightAnchor.constraint(equalToConstant: ComponentConstants.leagueHeaderHeight)
        ])
        
        NSLayoutConstraint.activate([
            fixturesTable.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            fixturesTable.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            fixturesTable.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
        ])
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Fixtures"
        self.addChild(fixturesTableVC)
        
        fixturesTableVC.tableView.dataSource = self
        fixturesTableVC.tableView.delegate = self
        
        _Concurrency.Task {
            await loadLeagueHeaderDetails()
            await loadModel()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.hasLeagueChanged()) {
            _Concurrency.Task {
                await self.reloadSelectedLeague()
                await loadLeagueHeaderDetails()
                await loadModel()
                
                fixturesTableVC.tableView.reloadData()
            }
        }
    }
    
    override func loadLeagueHeaderDetails() async {
        await super.loadLeagueHeaderDetails()
        
        var filterOptions = [DataFilterOption]()
        filterOptions.append(DataFilterOption(displayName: "Today", value: FixtureFilterType.today.rawValue, isEnabled: true))
        filterOptions.append(DataFilterOption(displayName: "Upcoming", value: FixtureFilterType.upcoming.rawValue, isEnabled: false))
        filterOptions.append(DataFilterOption(displayName: "Past", value: FixtureFilterType.past.rawValue, isEnabled: false))
        
        self.leagueHeaderDetails.filter = LeagueDataFilter(title: nil, options: filterOptions)
        self.leagueHeader.configure(with: self.leagueHeaderDetails)
    }
    
    override func loadModel() async {
        initializeModel()
        
        guard let filterOption = self.getEnabledFilterOption(),
              let filterValue = FixtureFilterType(rawValue: filterOption.value) else {
            return
        }
        
        var fixtures = await fixturesService.getFixtures(leagueId: self.leagueHeaderDetails.leagueId, filterType: filterValue)
//        var fixtures = getMockFixtures(for: self.leagueHeaderDetails.leagueId, using: filterValue)
        
        if (filterValue == .past) {
            fixtures.sort { $0.overview.date > $1.overview.date }
        } else {
            fixtures.sort { $0.overview.date < $1.overview.date }
        }
        
        fixtures.enumerated().forEach { index, fixture in
            var fixture = fixture
            fixture.overview.status.type = FixtureStatusType.getStatusType(from: fixture.overview.status.short)
            
            let m1 = Int(fixture.league.matchday.replacingOccurrences(of: "Regular Season - ", with: ""))
            guard let m1 = m1 else {
                return
            }
            
            if index == 0 {
                fixtureMap[matchdays.count] = [fixture]
                matchdays.append(m1)
                
                return
            }
            
            let pastFixture = fixtures[index - 1]
            
            let m2 = Int(pastFixture.league.matchday.replacingOccurrences(of: "Regular Season - ", with: ""))
            guard let m2 = m2 else {
                return
            }
            
            if m1 == m2 {
                fixtureMap[matchdays.count - 1]?.append(fixture)
                return
            }
            
            fixtureMap[matchdays.count] = [fixture]
            matchdays.append(m1)
        }
        
        fixturesTableVC.tableView.reloadData()
    }
}

extension FixturesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return matchdays.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fixtureMap[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FixturesTableHeader.identifier) as! FixturesTableHeader
        let matchday = matchdays[section]
        
        header.configure(with: matchday)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FixturesTableCell.identifier, for: indexPath) as! FixturesTableCell
        let fixture = fixtureMap[indexPath.section]![indexPath.row]

        cell.configure(with: fixture)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == tableView.numberOfSections - 1 {
            return nil
        }
        
        return UIView()
    }
}

extension FixturesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppConstants.baseCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstants.baseCellHeight * 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections - 1 {
            return 0
        }
        
        return AppConstants.baseSectionSpacing
    }
}

/// Private methods
extension FixturesViewController {
    
    private func initializeModel() {
        if !matchdays.isEmpty {
            matchdays.removeAll()
        }

        if !fixtureMap.isEmpty {
            fixtureMap.removeAll()
        }
    }
    
    // MARK: Mock Data
    
    private func getMockFixtures(for leagueId: Int, using filterValue: FixtureFilterType) -> [Fixture] {
        let daysSince = numberOfDaysSince(Date.getDateFromISO8601(using: "2023-05-14T12:00:00Z")!)
        var fileName: String
        
        switch filterValue {
        case .inPlay:
            fileName = "fixtures-inPlay-\(leagueId)"
        case .today:
            fileName = "fixtures-today-\(leagueId)"
        case .upcoming:
            fileName = "fixtures-upcoming-\(leagueId)"
        case .past:
            fileName = "fixtures-past-\(leagueId)"
        }
        
        let fixtures = JSONLoader.loadJSONData(from: fileName, decodingType: FixturesResponse.self)?.response
        guard var fixtures = fixtures else {
            return [Fixture]()
        }
        
        if fileName.range(of: "today", options: .caseInsensitive) != nil {
            fixtures = fixtures.map { fixture in
                var fixture = fixture
                fixture.overview.date = updateISODateString(isoString: fixture.overview.date, byDays: daysSince)!
                
                return fixture
            }
        }
        
        return fixtures
    }
    
    private func numberOfDaysSince(_ date: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let components = calendar.dateComponents([.day], from: date, to: currentDate)
        let days = components.day ?? 0
        
        return days
    }
    
    private func updateISODateString(isoString: String, byDays days: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: isoString) {
            let updatedDate = Calendar.current.date(byAdding: .day, value: days, to: date)
            let updatedString = dateFormatter.string(from: updatedDate!)
            
            return updatedString
        }
        
        return nil
    }
}
