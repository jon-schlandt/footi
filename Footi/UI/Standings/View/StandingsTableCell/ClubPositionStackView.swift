//
//  ClubPositionStackView.swift
//  Footi
//
//  Created by Jon Schlandt on 4/24/23.
//

import UIKit

class ClubPositionStackView: UIStackView {
    
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
    
    private let clubView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 10
        
        return view
    }()
    
    private let clubBadge: UIImageView = {
        let badge = UIImageView()
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            badge.widthAnchor.constraint(equalToConstant: ComponentConstants.clubBadgeWidth),
            badge.heightAnchor.constraint(equalToConstant: ComponentConstants.clubBadgeWidth)
        ])
        
        return badge
    }()
    
    private let clubTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        title.textColor = UIColor.Palette.primaryText
        
        return title
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        self.spacing = 10
        
        positionView.addSubview(positionLabel)
        clubView.addArrangedSubview(clubBadge)
        clubView.addArrangedSubview(clubTitle)
        
        self.addArrangedSubview(positionView)
        self.addArrangedSubview(clubView)
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
    
    public func configure(with standing: Standing) {
        positionLabel.text = String(standing.rank)
        clubBadge.loadFromCache(url: URL(string: standing.club.logo)!)
        clubTitle.text = standing.club.name
    }
    
    public func initialize() {
        positionLabel.text = nil
        clubBadge.image = nil
        clubTitle.text = nil
    }
}
