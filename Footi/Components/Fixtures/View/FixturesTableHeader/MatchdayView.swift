//
//  MatchdayView.swift
//  Footi
//
//  Created by Jon Schlandt on 6/8/23.
//

import Foundation
import UIKit

class MatchdayView: UIView {
    
    // MARK: View
    
    private let matchdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.title, size: FontConstants.standardSize)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(matchdayLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            matchdayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            matchdayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: AppConstants.baseMargin)
        ])
    }
    
    // MARK: Public
    
    public func configure(with matchday: Int) {
        matchdayLabel.text = "Matchday \(matchday)"
    }
}
