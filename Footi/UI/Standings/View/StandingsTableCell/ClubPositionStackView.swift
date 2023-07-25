//
//  ClubPositionStackView.swift
//  Footi
//
//  Created by Jon Schlandt on 4/24/23.
//

import UIKit

class ClubPositionStackView: UIStackView {
    
    // MARK: Subviews
    
    private let positionView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .equalCentering
        view.spacing = 2
        
        return view
    }()
    
    private let upIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.up")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 8.0, weight: .semibold, scale: .medium))
        imageView.tintColor = UIColor.systemGreen
        imageView.alpha = 0.0
        
        return imageView
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    private let downIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.down")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 8.0, weight: .semibold, scale: .medium))
        imageView.tintColor = UIColor.systemRed
        imageView.alpha = 0.0
        
        return imageView
    }()
    
    private let clubView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 8
        
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
    
    private let clubTitleView: UIView = {
        return UIView()
    }()
    
    private let clubTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        title.textColor = UIColor.Palette.primaryText
        
        return title
    }()
    
    private let inPlayIndicator: InPlayIndicator = {
        let indicator = InPlayIndicator()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        
        return indicator
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        self.spacing = 10
        
        positionView.addArrangedSubview(upIndicator)
        positionView.addArrangedSubview(positionLabel)
        positionView.addArrangedSubview(downIndicator)
        self.addArrangedSubview(positionView)
        
        clubTitleView.addSubview(clubTitle)
        clubTitleView.addSubview(inPlayIndicator)
        
        clubView.addArrangedSubview(clubBadge)
        clubView.addArrangedSubview(clubTitleView)
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
        
        NSLayoutConstraint.activate([
            clubTitle.centerYAnchor.constraint(equalTo: clubTitleView.centerYAnchor),
            clubTitle.leadingAnchor.constraint(equalTo: clubTitleView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            inPlayIndicator.widthAnchor.constraint(equalToConstant: 20),
            inPlayIndicator.heightAnchor.constraint(equalToConstant: 5),
            inPlayIndicator.centerYAnchor.constraint(equalTo: clubTitleView.centerYAnchor),
            inPlayIndicator.leadingAnchor.constraint(equalTo: clubTitle.trailingAnchor, constant: 8)
        ])
    }
    
    // MARK: Public methods
    
    public func configure(with standing: Standing) {
        positionLabel.text = String(standing.position.total)
        clubBadge.loadFromCache(url: standing.clubLogo)
        clubTitle.text = standing.clubTitle
        
        if let positionModifier = standing.position.modifier {
            if positionModifier > 0 {
                downIndicator.alpha = 1.0
            }
            
            if positionModifier < 0 {
                upIndicator.alpha = 1.0
            }
        }
        
        if standing.inPlay {
            inPlayIndicator.beginAnimation()
            inPlayIndicator.isHidden = false
        }
    }
    
    public func initialize() {
        positionLabel.text = nil
        clubBadge.image = nil
        clubTitle.text = nil
        
        upIndicator.alpha = 0.0
        downIndicator.alpha = 0.0
        
        inPlayIndicator.initialize()
        inPlayIndicator.isHidden = true
    }
}
