//
//  StandingStatTitleCell.swift
//  Footi
//
//  Created by Jon Schlandt on 4/27/23.
//

import UIKit

class StandingStatTitleCell: UICollectionViewCell {
    
    static let identifier = String(describing: StandingStatTitleCell.self)
    
    // MARK: Views
    
    public let statTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: FontConstants.title, size: FontConstants.standardSize)
        title.textColor = UIColor.Palette.tertiaryText
        
        return title
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(statTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            statTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            statTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statTitle.text = nil
    }
}
