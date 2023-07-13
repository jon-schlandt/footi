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
    
    private let statView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .equalCentering
        view.spacing = 2
        
        return view
    }()
    
    private let statLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    private let statModifier: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.paragraph, size: 10.0)
        label.textColor = UIColor.Palette.emphasisIcon
        
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        statView.addArrangedSubview(statLabel)
        self.contentView.addSubview(statView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            statView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            statView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        statLabel.text = nil
        statLabel.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        
        statModifier.text = nil
    }
    
    // MARK: Public
    
    public func configure(stat: StandingStat, index: Int) {
        statLabel.text = String(stat.value)
        
        if let modifier = stat.modifier {
            statView.addArrangedSubview(statModifier)
            statModifier.text = "\(modifier >= 0 ? "+" : "")" + "\(modifier)"
        }
        
        if index == 2 {
            statLabel.font = UIFont(name: FontConstants.title, size: FontConstants.standardSize)
        }
    }
}
