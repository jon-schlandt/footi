//
//  SettingSelectionCell.swift
//  Footi
//
//  Created by Jon Schlandt on 4/5/23.
//

import UIKit

class SettingSelectionCell: UITableViewCell {

    static let identifier = String(describing: SettingSelectionCell.self)
    
    // MARK: View
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        
        return label
    }()
    
    private let checkmark: UIImageView = {
        let checkmark = UIImageView()
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.contentMode = .scaleAspectFit
        checkmark.image = UIImage(systemName: "checkmark.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16.0, weight: .light, scale: .medium))
        checkmark.tintColor = UIColor.Palette.secondaryIcon
        checkmark.isHidden = true
        
        return checkmark
    }()
    
    // MARK: Model
    
    public var key: String!
    public var isEnabled = false
    
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
            label.trailingAnchor.constraint(equalTo: checkmark.leadingAnchor),
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
        
        key = nil
        label.text = nil
        checkmark.isHidden = true
    }
    
    // MARK: Public
    
    public func configure(with selection: SettingSelection) {
        key = selection.key
        isEnabled = selection.isEnabled ?? false
        
        label.text = selection.title
        
        if selection.isEnabled == true {
            checkmark.isHidden = false
        } else {
            checkmark.isHidden = true
        }
    }
}

/// Private methods
extension SettingSelectionCell {
    
    private func setStyling() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.Palette.foreground
        
        self.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
