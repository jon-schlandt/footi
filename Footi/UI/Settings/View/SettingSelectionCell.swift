//
//  SettingSelectionCell.swift
//  Footi
//
//  Created by Jon Schlandt on 4/5/23.
//

import UIKit

class SettingSelectionCell: BaseTableCell {

    static let identifier = String(describing: SettingSelectionCell.self)
    
    // MARK: View
    
    private let selectionLabel: UILabel = {
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
        
        return checkmark
    }()
    
    // MARK: Model
    
    public var selection: SettingSelection?
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(selectionLabel)
        self.contentView.addSubview(checkmark)
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            selectionLabel.trailingAnchor.constraint(equalTo: checkmark.leadingAnchor),
            selectionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: AppConstants.baseMargin),
            selectionLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkmark.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -AppConstants.baseMargin),
            checkmark.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        selection = nil
        selectionLabel.text = nil
        selectionLabel.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        checkmark.isHidden = true
    }
    
    // MARK: Public
    
    public func configure(with selection: SettingSelection, isLast: Bool) {
        super.configure(isLast: isLast)
        
        self.selection = selection
        selectionLabel.text = self.selection?.title
        
        if self.selection?.isEnabled == true {
            checkmark.isHidden = false
            selectionLabel.font = UIFont(name: FontConstants.title, size: FontConstants.standardSize)
        } else {
            checkmark.isHidden = true
            selectionLabel.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        }
    }
}

/// Private methods
extension SettingSelectionCell {
    
    private func setStyling() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.Palette.foreground
    }
}
