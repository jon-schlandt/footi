//
//  PlayerPositionStackView.swift
//  Footi
//
//  Created by Jon Schlandt on 5/31/23.
//

import UIKit

class PlayerPositionStackView: UIStackView {

    // MARK: View
    
    private let positionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    private let playerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 10
        
        return view
    }()
    
    private let playerImage = PlayerImageView()
    
    private let playerNameView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalCentering
        view.spacing = 2
        
        return view
    }()
    
    private let playerName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontConstants.title, size: FontConstants.standardSize)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    private let playerClub: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontConstants.paragraph, size: FontConstants.extraSmallSize)
        label.textColor = UIColor.Palette.secondaryText
        
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .fill
        self.spacing = 10
        
        positionView.addSubview(positionLabel)
        self.addArrangedSubview(positionView)
        
        playerNameView.addArrangedSubview(playerName)
        playerNameView.addArrangedSubview(playerClub)
        playerView.addArrangedSubview(playerImage)
        playerView.addArrangedSubview(playerNameView)
        self.addArrangedSubview(playerView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            positionView.widthAnchor.constraint(equalToConstant: 18),
            positionLabel.centerXAnchor.constraint(equalTo: positionView.centerXAnchor),
            positionLabel.centerYAnchor.constraint(equalTo: positionView.centerYAnchor)
        ])
    }
    
    // MARK: Public
    
    public func configure(with leader: Leader) {
        positionLabel.text = String(leader.overview.position!)
        playerImage.playerImage.loadFromCache(url: URL(string: leader.overview.image)!)
        playerName.text = getDisplayName(displayName: leader.overview.displayName, firstName: leader.overview.firstName)
        playerClub.text = leader.stats[0].club.name
    }
    
    public func initialize() {
        positionLabel.text = nil
        playerImage.playerImage.image = nil
        playerName.text = nil
        playerClub.text = nil
    }
}

/// Private methods
extension PlayerPositionStackView {
    
    private func getDisplayName(displayName: String, firstName: String) -> String {
        let names = displayName.split(separator: " ")
        if names.count <= 1 {
            return displayName
        }

        if !names[0].hasSuffix(".") {
            return displayName
        }
        
        var displayName = firstName.split(separator: " ")[0]
        names.enumerated().forEach() { index, name in
            if index != 0 {
                displayName += " \(name)"
            }
        }
        
        return String(displayName)
    }
}
