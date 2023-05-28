//
//  MatchupSideStackView.swift
//  Footi
//
//  Created by Jon Schlandt on 5/14/23.
//

import UIKit

class MatchupSideStackView: UIStackView {

    // MARK: Views
    
    let clubView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 10
        
        return view
    }()
    
    let clubBadge: UIImageView = {
        let badge = UIImageView()
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            badge.widthAnchor.constraint(equalToConstant: ComponentConstants.clubBadgeWidth),
            badge.heightAnchor.constraint(equalToConstant: ComponentConstants.clubBadgeWidth)
        ])
        
        return badge
    }()
    
    let clubTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontConstants.standardSize)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    let scoreView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 10
        
        return view
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontConstants.standardSize)
        label.textColor = UIColor.Palette.primaryText
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        return label
    }()
    
    let winIndicator: UIImageView = {
        let indicator = UIImageView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.contentMode = .scaleAspectFit
        indicator.image = UIImage(systemName: "arrowtriangle.left.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))
        indicator.tintColor = UIColor.Palette.secondaryIcon
        indicator.alpha = 0.0
        
        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalToConstant: 11),
            indicator.heightAnchor.constraint(equalToConstant: 11)
        ])
        
        return indicator
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.axis = .horizontal
        self.distribution = .equalSpacing
        self.alignment = .center
        
        clubView.addArrangedSubview(clubBadge)
        clubView.addArrangedSubview(clubTitle)
        self.addArrangedSubview(clubView)
        
        scoreView.addArrangedSubview(scoreLabel)
        scoreView.addArrangedSubview(winIndicator)
        self.addArrangedSubview(scoreView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    
    public func initialize() {
        clubBadge.image = nil
        clubTitle.text = nil
        scoreLabel.text = nil
        scoreLabel.textColor = UIColor.Palette.primaryText
        winIndicator.alpha = 0.0
    }
}
