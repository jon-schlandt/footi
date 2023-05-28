//
//  FixtureMatchupView.swift
//  Footi
//
//  Created by Jon Schlandt on 5/13/23.
//

import UIKit

class FixtureMatchupView: UIView {
    
    // MARK: Views
    
    let container: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 24
        
        return view
    }()
    
    let homeSide: MatchupSideStackView = {
        let side = MatchupSideStackView()
        side.alignment = .bottom
        
        return side
    }()
    
    let awaySide: MatchupSideStackView = {
        let side = MatchupSideStackView()
        side.alignment = .top
        
        return side
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(container)
        container.addArrangedSubview(homeSide)
        container.addArrangedSubview(awaySide)
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
    
    // MARK: Public
    
    public func configure(with fixture: Fixture) {
        homeSide.clubBadge.load(url: URL(string: fixture.matchup.home.logo)!)
        homeSide.clubTitle.text = fixture.matchup.home.name
        
        awaySide.clubBadge.load(url: URL(string: fixture.matchup.away.logo)!)
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
}
