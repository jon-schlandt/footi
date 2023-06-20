//
//  LeagueDisplayStackView.swift
//  Footi
//
//  Created by Jon Schlandt on 4/13/23.
//

import UIKit

class LeagueDisplayStackView: UIStackView {
    
    // MARK: View

    private let leagueLogo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private let leagueTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: FontConstants.title, size: FontConstants.largeSize)
        title.textColor = UIColor.Palette.primaryText
        
        return title
    }()
    
    private let separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.Palette.border
        separator.isHidden = false
        
        return separator
    }()
    
    private let liveImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "live")
        image.isHidden = false
        
        return image
    }()
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        self.spacing = 10
        
        self.addArrangedSubview(leagueLogo)
        self.addArrangedSubview(leagueTitle)
        self.addArrangedSubview(separator)
        self.addArrangedSubview(liveImage)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            leagueLogo.widthAnchor.constraint(equalToConstant: 22),
            leagueLogo.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: AppConstants.baseBorderWidth),
            separator.topAnchor.constraint(equalTo: self.topAnchor, constant: AppConstants.baseMargin + 2),
            separator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -AppConstants.baseMargin - 2)
        ])
        
        NSLayoutConstraint.activate([
            liveImage.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    // MARK: Public
    
    public func configure(with headerDetails: LeagueHeaderDetails) {
        leagueLogo.image = UIImage(named: String(headerDetails.leagueId))
        leagueTitle.text = headerDetails.leagueTitle
    }
}
