//
//  FinishedStatusView.swift
//  Footi
//
//  Created by Jon Schlandt on 5/17/23.
//

import UIKit

class FinishedStatusView: UIStackView, FixtureStatusView {

    // MARK: Views
    
    let statusView: UIView = {
        let view = UIView()
        return view
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: FontConstants.smallSize, weight: .semibold)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    let dateView: UIView = {
        let view = UIView()
        return view
    }()
    
    let dateLabel: UILabel = {
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
        
        statusView.addSubview(statusLabel)
        self.addArrangedSubview(statusView)
        
        dateView.addSubview(dateLabel)
        self.addArrangedSubview(dateView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: statusView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: dateView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: dateView.topAnchor)
        ])
    }
    
    // MARK: Public
    
    public func configure(with fixture: Fixture) {
        guard let fixtureDate = Date.getDateFromISO8601(using: fixture.overview.date) else {
            return
        }
        
        statusLabel.text = fixture.overview.status.short
        
        let isToday = Calendar.current.isDate(fixtureDate, inSameDayAs: Date())
        if isToday {
            dateLabel.text = "Today"
        } else {
            dateLabel.text = Date.getDateString(from: fixtureDate, as: "E, MMM d")
        }
    }
}
