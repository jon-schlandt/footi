//
//  FinishedStatusView.swift
//  Footi
//
//  Created by Jon Schlandt on 5/17/23.
//

import UIKit

class FinishedStatusView: UIStackView, FixtureStatusView {

    // MARK: Subviews
    
    private let statusView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.title, size: FontConstants.smallSize)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    private let dateView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.paragraph, size: FontConstants.smallSize)
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
    
    // MARK: Public methods
    
    public func configure(with fixture: FixtureResponse) {
        guard let fixtureDate = Date.getDateFromISO8601(using: fixture.overview.date) else {
            return
        }
        
        statusLabel.text = fixture.overview.status.short
        
        if Calendar.current.isDate(fixtureDate, inSameDayAs: Date()) {
            dateLabel.text = "Today"
        } else if Calendar.current.isDateInYesterday(fixtureDate) {
            dateLabel.text = "Yesterday"
        } else {
            dateLabel.text = Date.getDateString(from: fixtureDate, as: "E, MMM d")
        }
    }
}
