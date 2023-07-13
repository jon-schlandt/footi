//
//  FixtureMatchupView.swift
//  Footi
//
//  Created by Jon Schlandt on 5/13/23.
//

import UIKit

class FixtureMatchupView: UIView {
    
    // MARK: Subviews
    
    private let container: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 20
        
        return view
    }()
    
    private let homeSide: MatchupSideStackView = {
        let side = MatchupSideStackView()
        side.alignment = .bottom
        
        return side
    }()
    
    private let awaySide: MatchupSideStackView = {
        let side = MatchupSideStackView()
        side.alignment = .top
        
        return side
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        container.addArrangedSubview(homeSide)
        container.addArrangedSubview(awaySide)
        self.addSubview(container)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        ])
    }
    
    // MARK: Public methods
    
    public func configure(with fixture: FixtureResponse) {
        homeSide.clubBadge.loadFromCache(url: URL(string: fixture.matchup.home.logo)!)
        homeSide.clubTitle.text = fixture.matchup.home.name
        
        awaySide.clubBadge.loadFromCache(url: URL(string: fixture.matchup.away.logo)!)
        awaySide.clubTitle.text = fixture.matchup.away.name
        
        guard let homeScore = fixture.score.home,
              let awayScore = fixture.score.away else {
            return
        }
        
        homeSide.scoreLabel.text = String(homeScore)
        awaySide.scoreLabel.text = String(awayScore)
        
        if fixture.overview.status.short == "FT" {
            if fixture.matchup.home.isWinner ?? false {
                homeSide.winIndicator.alpha = 1.0
                awaySide.scoreLabel.textColor = UIColor.Palette.secondaryText
            }
            
            if fixture.matchup.away.isWinner ?? false {
                awaySide.winIndicator.alpha = 1.0
                homeSide.scoreLabel.textColor = UIColor.Palette.secondaryText
            }
        }
    }
    
    public func initialize() {
        homeSide.initialize()
        awaySide.initialize()
    }
}
