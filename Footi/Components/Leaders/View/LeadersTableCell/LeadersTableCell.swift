//
//  LeadersTableCell.swift
//  Footi
//
//  Created by Jon Schlandt on 5/29/23.
//

import UIKit

class LeadersTableCell: UITableViewCell {
    
    static let identifier = String(describing: LeadersTableCell.self)
    
    // MARK: View
    
    private let container: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .horizontal
        container.distribution = .equalSpacing
        
        return container
    }()
    
    private let playerPositionView = PlayerPositionStackView()
    private let playerStatView = PlayerStatView()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        container.addArrangedSubview(playerPositionView)
        container.addArrangedSubview(playerStatView)
        self.contentView.addSubview(container)
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            container.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -AppConstants.baseMargin),
            container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: AppConstants.baseMargin)
        ])
        
        NSLayoutConstraint.activate([
            playerStatView.widthAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playerPositionView.initialize()
        playerStatView.initialize()
    }
    
    // MARK: Public
    
    public func configure(with leader: Leader, filterType: LeaderFilterType) {
        playerPositionView.configure(with: leader)
        
        var stat: Int
        
        switch filterType {
        case .goals:
            stat = leader.stats[0].goals.scored ?? 0
        case .assists:
            stat = leader.stats[0].goals.assisted ?? 0
        case .yellowCards:
            stat = leader.stats[0].cards.yellow ?? 0
        case .redCards:
            stat = leader.stats[0].cards.red ?? 0
        }
        
        playerStatView.configure(with: String(stat))
    }
}

/// Private methods
extension LeadersTableCell {
    
    private func setStyling() {
        self.contentView.backgroundColor = UIColor.Palette.foreground
        self.contentView.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
