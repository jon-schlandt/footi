//
//  FixturesTableViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 7/8/23.
//

import UIKit

class FixturesTableViewController: BaseTableViewController {

    // MARK: Model
    
    override var model: Any! {
        didSet {
            generateFixtureMap()
        }
    }
    
    private var matchdays = [Int]()
    private var fixtureMap = [Int: [FixtureResponse]]()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        self.tableView.register(FixturesTableHeader.self, forHeaderFooterViewReuseIdentifier: FixturesTableHeader.identifier)
        self.tableView.register(FixturesTableCell.self, forCellReuseIdentifier: FixturesTableCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return matchdays.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fixtureMap[section]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FixturesTableHeader.identifier) as! FixturesTableHeader
        let matchday = matchdays[section]
        
        header.configure(with: matchday)
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if fixtureMap.isEmpty {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FixturesTableCell.identifier, for: indexPath) as! FixturesTableCell
        let fixture = fixtureMap[indexPath.section]![indexPath.row]
        let isLast = indexPath.row == (fixtureMap[indexPath.section]?.count ?? 0) - 1
        
        cell.configure(with: fixture, isLast: isLast)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppConstants.baseCellHeight + AppConstants.baseSectionSpacing
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstants.baseCellHeight * 2
    }
}

// MARK: Private methods

extension FixturesTableViewController {
    
    private func generateFixtureMap() {
        let fixtures = self.model as? [FixtureResponse]
        guard let fixtures = fixtures else {
            return
        }
        
        matchdays.removeAll()
        fixtureMap.removeAll()
        
        fixtures.enumerated().forEach { index, fixture in
            var fixture = fixture
            fixture.overview.status.type = FixtureStatusType.getStatusType(from: fixture.overview.status.short)
            
            #if DEBUG
            fixture.overview.date = setMockDate(using: fixture.overview.date)
            #endif
            
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
    }
    
    private func setMockDate(using date: String) -> String {
        let originalDate = Date.getDateFromISO8601(using: date)!
        let daysSince = numberOfDaysSince(Date.getDateFromISO8601(using: "2023-05-14T12:00:00Z")!)
        
        let mockYesterday = Date.getDateFromISO8601(using: "2023-05-13T12:00:00Z")!
        let mockToday = Date.getDateFromISO8601(using: "2023-05-14T12:00:00Z")!
        let mockTomorrow = Date.getDateFromISO8601(using: "2023-05-15T12:00:00Z")!
        
        if Calendar.current.isDate(originalDate, inSameDayAs: mockYesterday)
            || Calendar.current.isDate(originalDate, inSameDayAs: mockToday)
            || Calendar.current.isDate(originalDate, inSameDayAs: mockTomorrow) {
            return updateISODateString(isoString: date, byDays: daysSince)!
        }
        
        return date
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
