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
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    private let checkmark: UIImageView = {
        let checkmark = UIImageView()
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.contentMode = .scaleAspectFit
        checkmark.tintColor = UIColor.Palette.secondaryIcon
        checkmark.image = UIImage(systemName: "checkmark")
        checkmark.isHidden = true
        
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
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkmark.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            checkmark.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 18),
            checkmark.heightAnchor.constraint(equalToConstant: 18)
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
        isEnabled = selection.isEnabled
        
        label.text = selection.title
        
        if selection.isEnabled == true {
            checkmark.isHidden = false
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
