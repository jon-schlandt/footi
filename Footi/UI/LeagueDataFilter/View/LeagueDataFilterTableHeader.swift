//
//  LeagueDataFilterTableHeader.swift
//  Footi
//
//  Created by Jon Schlandt on 6/20/23.
//

import UIKit

class LeagueDataFilterTableHeader: UITableViewHeaderFooterView {
    
    public static let identifier = String(describing: LeagueDataFilterTableHeader.self)
    
    // MARK: Subviews
    
    private let background: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor.Palette.foreground
        
        return background
    }()

    private let filterTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let filterTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.title, size: FontConstants.standardSize)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundView = background
        
        filterTitleView.addSubview(filterTitleLabel)
        self.contentView.addSubview(filterTitleView)
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            filterTitleView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            filterTitleView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            filterTitleLabel.centerXAnchor.constraint(equalTo: filterTitleView.centerXAnchor),
            filterTitleLabel.centerYAnchor.constraint(equalTo: filterTitleView.centerYAnchor)
        ])
    }
    
    // MARK: Public methods
    
    public func configure(with filterTitle: String) {
        filterTitleLabel.text = filterTitle
    }
}

// MARK: Private methods

extension LeagueDataFilterTableHeader {
    
    private func setStyling() {
        _ = self.contentView.addBorders(edges: [.bottom], color: UIColor.Palette.primaryBorder!)
    }
}
