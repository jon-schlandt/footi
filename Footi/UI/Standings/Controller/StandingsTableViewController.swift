//
//  StandingsTableViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 7/8/23.
//

import UIKit

class StandingsTableViewController: BaseTableViewController {
    
    // MARK: Subviews

    private var statViews = [UIScrollView]()
    
    // MARK: Model
    
    private var standings: [Standing] {
        if self.model is [Standing] {
            return self.model as! [Standing]
        }
        
        return [Standing]()
    }
    
    private var statsOffset: CGPoint = CGPoint() {
        didSet {
            statViews.forEach { view in
                if view.contentOffset != statsOffset {
                    view.contentOffset = statsOffset
                }
            }
        }
    }
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        self.tableView.register(StandingsTableHeader.self, forHeaderFooterViewReuseIdentifier: StandingsTableHeader.identifier)
        self.tableView.register(StandingsTableCell.self, forCellReuseIdentifier: StandingsTableCell.identifier)
    }
    
    // MARK: UITableViewControllerDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.standings.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: StandingsTableHeader.identifier) as! StandingsTableHeader
        header.scrollDelegate = self
        
        statViews.append(header.statTitleView)
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if standings.isEmpty {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: StandingsTableCell.identifier, for: indexPath) as! StandingsTableCell
        let standing = standings[indexPath.row]
        let isLast = indexPath.row == standings.count - 1
        
        if !statViews.contains(cell.statsView) {
            statViews.append(cell.statsView)
        }
        
        cell.scrollDelegate = self
        cell.configure(with: standing, isLast: isLast)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? StandingsTableCell else {
            return
        }
        
        if cell.statsView.contentOffset != statsOffset {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                cell.statsView.contentOffset = self.statsOffset
            }
        }
    }
    
    // MARK: UITableViewControllerDelegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppConstants.baseCellHeight + AppConstants.baseSectionSpacing
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstants.baseCellHeight
    }
    
    // MARK: Base overrides
    
    override func setTableToOrigin() {
        super.setTableToOrigin()
        statsOffset = CGPoint()
    }
}

// MARK: Delegates

extension StandingsTableViewController: StandingsScrollViewDelegate {
    
    internal func setStatsOffset(originatingView: UIScrollView, offset: CGPoint) {
        guard statsOffset != offset else {
            return
        }
        
        statsOffset = offset
    }
}
