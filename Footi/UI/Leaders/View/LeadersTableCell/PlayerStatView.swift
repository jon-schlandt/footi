//
//  PlayerStatView.swift
//  Footi
//
//  Created by Jon Schlandt on 6/3/23.
//

import UIKit

class PlayerStatView: UIView {

    // MARK: View
    
    private let playerStat: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()

    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(playerStat)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            playerStat.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playerStat.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // MARK: Public
    
    public func configure(with stat: String) {
        playerStat.text = stat
    }
    
    public func initialize() {
        playerStat.text = nil
    }
}
