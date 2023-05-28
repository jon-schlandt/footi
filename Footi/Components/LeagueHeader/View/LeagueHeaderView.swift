//
//  LeagueHeaderView.swift
//  Footi
//
//  Created by Jon Schlandt on 4/11/23.
//

import UIKit

protocol LeagueHeaderViewDelegate: AnyObject {
    func presentFilter()
}

class LeagueHeaderView: UIView {
    
    // MARK: Views
    
    let container: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .horizontal
        container.distribution = .equalSpacing
        container.alignment = .center

        return container
    }()
    
    let leagueDisplay = LeagueDisplayStackView()
    let filterDropdown = LeagueDataFilterDropdown()
    
    // MARK: Model
    
    weak var delegate: LeagueHeaderViewDelegate?
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        filterDropdown.delegate = self
        
        container.addArrangedSubview(leagueDisplay)
        container.addArrangedSubview(filterDropdown)
        self.addSubview(container)
        
        setStyling()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -AppConstants.baseMargin),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: AppConstants.baseMargin)
        ])
    }
    
    public func configure(with headerDetails: LeagueHeaderDetails) {
        leagueDisplay.leagueLogo.image =  UIImage(named: String(headerDetails.leagueId))
        leagueDisplay.leagueTitle.text = headerDetails.leagueTitle
        filterDropdown.options = headerDetails.filter.options
    }
}

extension LeagueHeaderView: LeagueDataFilterDropdownDelegate {
    
    internal func presentFilter() {
        delegate?.presentFilter()
    }
}

/// Private methods
extension LeagueHeaderView {
    
    private func setStyling() {
        self.backgroundColor = UIColor.Palette.foreground
        self.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
