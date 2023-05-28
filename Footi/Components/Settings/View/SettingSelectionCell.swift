//
//  SettingSelectionCell.swift
//  Footi
//
//  Created by Jon Schlandt on 4/5/23.
//

import UIKit

class SettingSelectionCell: UITableViewCell {

    static let identifier = String(describing: SettingSelectionCell.self)
    
    // MARK: Views
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: FontConstants.standardSize)
        
        return label
    }()
    
    private let checkmark: UIImageView = {
        let checkmark = UIImageView()
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.contentMode = .scaleAspectFit
        checkmark.tintColor = UIColor.Palette.secondaryIcon
        
        return checkmark
    }()
    
    // MARK: Model
    
    var key: String!
    var isEnabled: Bool!
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(checkmark)
        
        self.style()
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
            checkmark.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 20),
            checkmark.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        key = nil
        label.text = nil
        checkmark.image = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .light))
    }
    
    // MARK: Public
    
    public func configure(with selection: SettingSelection) {
        key = selection.key
        isEnabled = selection.isEnabled
        
        label.text = selection.title
        
        if selection.isEnabled == true {
            checkmark.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))
        } else {
            checkmark.image = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .light))
        }
    }
}

/// Private methods
extension SettingSelectionCell {
    
    private func style() {
        self.selectionStyle = .none
        
        self.contentView.backgroundColor = UIColor.Palette.foreground
        self.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
