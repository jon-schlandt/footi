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
    
    weak var delegate: LeagueHeaderViewDelegate?
    
    // MARK: Subviews
    
    private let container: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .horizontal
        container.distribution = .equalSpacing
        container.alignment = .center

        return container
    }()
    
    private let leagueDisplay = LeagueDisplayStackView()
    private let filterDropdown = LeagueDataFilterDropdown()
    
    // MARK: Lifecycle
    
    init(isLoading: Bool = false) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.zPosition = 1
        
        container.addArrangedSubview(leagueDisplay)
        
        if !isLoading {
            filterDropdown.delegate = self
            container.addArrangedSubview(filterDropdown)
        }
        
        self.addSubview(container)
        setStyling()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: ComponentConstants.leagueHeaderHeight)
        ])
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -AppConstants.baseMargin),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: AppConstants.baseMargin)
        ])
    }
    
    // MARK: Public methods
    
    public func configure(with headerDetails: LeagueHeaderDetails) {
        leagueDisplay.configure(with: headerDetails)
        filterDropdown.configure(with: headerDetails.filter.options)
    }
    
    public func resetDropdown() {
        filterDropdown.resetDropdown()
    }
}

// MARK: Delegates

extension LeagueHeaderView: LeagueDataFilterDropdownDelegate {
    
    internal func presentFilter() {
        delegate?.presentFilter()
    }
}

// MARK: Private helpers

extension LeagueHeaderView {
    
    private func setStyling() {
        _ = self.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
        self.backgroundColor = UIColor.Palette.foreground
    }
}
