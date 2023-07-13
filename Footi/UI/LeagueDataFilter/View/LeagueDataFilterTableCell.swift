//
//  LeagueDataFilterTableCell.swift
//  Footi
//
//  Created by Jon Schlandt on 4/17/23.
//

import UIKit

class LeagueDataFilterTableCell: BaseTableCell {
    
    public static let identifier = String(describing: LeagueDataFilterTableCell.self)
    
    // MARK: Views
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    private let checkmark: UIImageView = {
        let checkmark = UIImageView()
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.contentMode = .scaleAspectFit
        checkmark.image = UIImage(systemName: "checkmark.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 13.0, weight: .medium, scale: .medium))
        checkmark.tintColor = UIColor.Palette.emphasisIcon
        checkmark.isHidden = true
        
        return checkmark
    }()
    
    // MARK: Model
    
    var value: String!
    var isEnabled: Bool!
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(checkmark)
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: checkmark.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: AppConstants.baseMargin),
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkmark.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -AppConstants.baseMargin),
            checkmark.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        value = nil
        label.text = nil
        label.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        checkmark.isHidden = true
    }
    
    // MARK: Public
    
    public func configure(with option: DataFilterOption, isLast: Bool) {
        super.configure(isLast: isLast)
        
        value = option.value
        isEnabled = option.isEnabled
        
        label.text = option.displayName
        
        if option.isEnabled {
            checkmark.isHidden = false
            label.font = UIFont(name: FontConstants.title, size: FontConstants.standardSize)
        } else {
            checkmark.isHidden = true
            label.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        }
    }
}

/// Private methods
extension LeagueDataFilterTableCell {
    
    private func setStyling() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.Palette.foreground
    }
}
