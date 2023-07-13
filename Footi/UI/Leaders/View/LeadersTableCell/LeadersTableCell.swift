//
//  LeadersTableCell.swift
//  Footi
//
//  Created by Jon Schlandt on 5/29/23.
//

import UIKit

class LeadersTableCell: BaseTableCell {
    
    static let identifier = String(describing: LeadersTableCell.self)
    
    // MARK: Subviews
    
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
            playerStatView.widthAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playerPositionView.initialize()
        playerStatView.initialize()
    }
    
    // MARK: Public methods
    
    public func configure(with leader: Leader, isLast: Bool) {
        super.configure(isLast: isLast)
        
        playerPositionView.configure(with: leader)
        playerStatView.configure(with: leader.statValue)
    }
}
