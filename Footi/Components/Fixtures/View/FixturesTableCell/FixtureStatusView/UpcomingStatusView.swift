//
//  UpcomingStatusView.swift
//  Footi
//
//  Created by Jon Schlandt on 5/17/23.
//

import UIKit

class UpcomingStatusView: UIStackView, FixtureStatusView {
    
    // MARK: Views
    
    let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: FontConstants.smallSize, weight: .semibold)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: FontConstants.smallSize)
        label.textColor = UIColor.Palette.secondaryText
        
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 6
        
        topView.addSubview(topLabel)
        bottomView.addSubview(bottomLabel)
        
        self.addArrangedSubview(topView)
        self.addArrangedSubview(bottomView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            topLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            bottomLabel.topAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
    }
    
    // MARK: Public

    public func configure(with fixture: Fixture) {
        let fixtureDate = Date.getDateFromISO8601(using: fixture.overview.date)
        guard let fixtureDate = fixtureDate else {
            return
        }
        
        let fixtureTime = Date.getDateString(from: fixtureDate, as: "h:mm a")
        
        if Calendar.current.isDate(fixtureDate, inSameDayAs: Date()) {
            topLabel.text = fixtureTime
            bottomLabel.text = "Today"
        } else {
            topLabel.text = Date.getDateString(from: fixtureDate, as: "E, MMM d")
            bottomLabel.text = fixtureTime
        }
    }
}
