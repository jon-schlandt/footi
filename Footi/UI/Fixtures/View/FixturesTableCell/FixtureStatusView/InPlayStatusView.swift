//
//  InPlayStatusView.swift
//  Footi
//
//  Created by Jon Schlandt on 5/16/23.
//

import UIKit

class InPlayStatusView: UIView, FixtureStatusView {

    // MARK: Views
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.title, size: FontConstants.smallSize)
        label.textColor = UIColor.Palette.emphasisIcon
        
        return label
    }()
    
    private let inPlayIndicator: UIView = {
        let indicator = UIView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.layer.cornerRadius = 5 / 2
        indicator.clipsToBounds = true
        indicator.backgroundColor = UIColor.Palette.background
        
        return indicator
    }()
    
    private let indicatorLight: UIView = {
        let light = UIView()
        light.translatesAutoresizingMaskIntoConstraints = false
        light.layer.cornerRadius = 5 / 2
        light.backgroundColor = UIColor.Palette.emphasisIcon
        
        return light
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        inPlayIndicator.addSubview(indicatorLight)
        
        self.addSubview(statusLabel)
        self.addSubview(inPlayIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            inPlayIndicator.widthAnchor.constraint(equalToConstant: 20),
            inPlayIndicator.heightAnchor.constraint(equalToConstant: 5),
            inPlayIndicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            inPlayIndicator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            indicatorLight.widthAnchor.constraint(equalToConstant: 5),
            indicatorLight.heightAnchor.constraint(equalToConstant: 5),
            indicatorLight.centerYAnchor.constraint(equalTo: inPlayIndicator.centerYAnchor),
            indicatorLight.leadingAnchor.constraint(equalTo: inPlayIndicator.leadingAnchor)
        ])
    }
    
    // MARK: Public
    
    public func configure(with fixture: Fixture) {
        if let minutesPlayed = fixture.overview.status.minutesPlayed {
            statusLabel.text = String(minutesPlayed) + "'"
        }
    }
}
