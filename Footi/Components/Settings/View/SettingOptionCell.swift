//
//  SettingsOptionCell.swift
//  Footi
//
//  Created by Jon Schlandt on 3/28/23.
//

import UIKit

class SettingOptionCell: UITableViewCell {

    static let identifier = String(describing: SettingOptionCell.self)
    
    // MARK: View
    
    private let label: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        title.textColor = UIColor.Palette.primaryText
        
        return title
    }()
    
    private let disclosureArrow: UIImageView = {
        let disclosureArrow = UIImageView()
        disclosureArrow.translatesAutoresizingMaskIntoConstraints = false
        disclosureArrow.contentMode = .scaleAspectFit
        disclosureArrow.tintColor = UIColor.Palette.secondaryIcon
        disclosureArrow.image = UIImage(systemName: "chevron.right")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 13.0, weight: .light, scale: .medium))
        
        return disclosureArrow
    }()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(disclosureArrow)
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: disclosureArrow.leadingAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: AppConstants.baseMargin),
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            disclosureArrow.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -AppConstants.baseMargin),
            disclosureArrow.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    // MARK: Public
    
    public func configure(with option: SettingOption) {
        label.text = option.title
    }
}

/// Private methods
extension SettingOptionCell {
    
    private func setStyling() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.Palette.foreground
        
        self.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
    
}
