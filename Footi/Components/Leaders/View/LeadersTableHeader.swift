//
//  LeadersTableHeader.swift
//  Footi
//
//  Created by Jon Schlandt on 5/29/23.
//

import UIKit

class LeadersTableHeader: UITableViewHeaderFooterView {
    
    static let identifier = String(describing: LeadersTableHeader.self)
    
    // MARK: Views
    
    private let background: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor.Palette.foreground
        
        return background
    }()
    
    private let leaderTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: FontConstants.standardSize, weight: .semibold)
        label.textColor = UIColor.Palette.tertiaryText
        label.text = "Leader"
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.baseMargin)
        ])
        
        return view
    }()
    
    // MARK: Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundView = background
        self.contentView.addSubview(leaderTitleView)
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            leaderTitleView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            leaderTitleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            leaderTitleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            leaderTitleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor)
        ])
    }
}

/// Private methods
extension LeadersTableHeader {
    
    private func setStyling() {
        self.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
