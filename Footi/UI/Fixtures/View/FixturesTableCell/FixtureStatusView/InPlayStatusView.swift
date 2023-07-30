//
//  InPlayStatusView.swift
//  Footi
//
//  Created by Jon Schlandt on 5/16/23.
//

import UIKit

class InPlayStatusView: UIView, FixtureStatusView {
    
    // MARK: Subviews
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.title, size: FontConstants.smallSize)
        label.textColor = UIColor.Palette.emphasis
        
        return label
    }()
    
    private let inPlayIndicator = InPlayIndicator()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(statusLabel)
        self.addSubview(inPlayIndicator)
        
        inPlayIndicator.beginAnimation()
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
    }
    
    // MARK: Public methods
    
    public func configure(with fixture: Fixture) {
        if let minutesPlayed = fixture.status.minutesPlayed {
            statusLabel.text = String(minutesPlayed) + "'"
        }
    }
}
