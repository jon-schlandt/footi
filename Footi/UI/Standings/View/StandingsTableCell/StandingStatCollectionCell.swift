//
//  StandingStatCollectionCell.swift
//  Footi
//
//  Created by Jon Schlandt on 4/27/23.
//

import UIKit

class StandingStatCollectionCell: UICollectionViewCell {
    
    static let identifier = String(describing: StandingStatCollectionCell.self)
    
    // MARK: View
    
    private let statLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(statLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            statLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            statLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        statLabel.font = UIFont.systemFont(ofSize: FontConstants.standardSize)
        statLabel.text = nil
    }
    
    // MARK: Public
    
    public func configure(stat: String, index: Int) {
        statLabel.text = stat
        
        if index == 3 {
            statLabel.font = UIFont(name: FontConstants.title, size: FontConstants.standardSize)
        }
    }
}
