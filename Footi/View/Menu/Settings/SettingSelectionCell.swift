//
//  SettingSelectionCell.swift
//  Footi
//
//  Created by Jon Schlandt on 4/5/23.
//

import UIKit

/// UITableViewCell methods
class SettingSelectionCell: UITableViewCell {

    static let identifier = "SettingSelectionCell"
    
    var key: String!
    var isEnabled: Bool!
    
    private let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 1
        
        return title
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(checkmark)
        
        self.style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            title.trailingAnchor.constraint(equalTo: checkmark.leadingAnchor),
            title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            title.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkmark.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            checkmark.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 20),
            checkmark.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        key = nil
        title.text = nil
        checkmark.isHidden = true
    }
    
    public func configure(with selection: SettingSelection) {
        key = selection.key
        isEnabled = selection.isEnabled
        
        title.text = selection.title
        
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
