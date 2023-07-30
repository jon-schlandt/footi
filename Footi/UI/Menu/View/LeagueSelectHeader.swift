//
//  LeagueSelectHeader.swift
//  Footi
//
//  Created by Jon Schlandt on 6/16/23.
//

import UIKit

class LeagueSelectHeader: UICollectionReusableView {
    
    public static let identifier = String(describing: LeagueSelectHeader.self)
    
    // MARK: Subviews
    
    private let leagueSelectTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.title, size: FontConstants.standardSize)
        label.textColor = UIColor.Palette.primaryText
        label.text = "League Select"
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.baseMargin)
        ])
        
        return view
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(leagueSelectTitleView)
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            leagueSelectTitleView.topAnchor.constraint(equalTo: self.topAnchor),
            leagueSelectTitleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            leagueSelectTitleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leagueSelectTitleView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
}

// MARK: Private helpers

extension LeagueSelectHeader {
    
    private func setStyling() {
        _ = self.addBorders(edges: [.bottom], color: UIColor.Palette.primaryBorder!)
        self.backgroundColor = UIColor.Palette.foreground
    }
}
