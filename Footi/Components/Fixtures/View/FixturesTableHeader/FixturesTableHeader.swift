//
//  FixturesTableHeader.swift
//  Footi
//
//  Created by Jon Schlandt on 5/8/23.
//

import UIKit

class FixturesTableHeader: UITableViewHeaderFooterView {
    
    static let identifier = String(describing: FixturesTableHeader.self)
    
    // MARK: Views
    
    private let background: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor.Palette.foreground
        
        return background
    }()
    
    private let matchdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: FontConstants.standardSize, weight: .semibold)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundView = background
        self.contentView.addSubview(matchdayLabel)
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            matchdayLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            matchdayLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: AppConstants.baseMargin)
        ])
    }
    
    // MARK: Public
    
    public func configure(with matchday: Int) {
        matchdayLabel.text = "Matchday \(matchday)"
    }
}

extension FixturesTableHeader {
    
    private func setStyling() {
        self.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
