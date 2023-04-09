//
//  SettingsOptionCell.swift
//  Footi
//
//  Created by Jon Schlandt on 3/28/23.
//

import UIKit

/// UITableViewCell methods
class SettingOptionCell: UITableViewCell {

    static let identifier = "SettingOptionCell"
    
    private let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 1
        
        return title
    }()
    
    private let disclosureArrow: UIImageView = {
        let disclosureArrow = UIImageView()
        disclosureArrow.translatesAutoresizingMaskIntoConstraints = false
        disclosureArrow.contentMode = .scaleAspectFit
        disclosureArrow.tintColor = UIColor.Palette.secondaryIcon
        disclosureArrow.image = UIImage(systemName: "chevron.right")
        
        return disclosureArrow
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(disclosureArrow)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            title.trailingAnchor.constraint(equalTo: disclosureArrow.leadingAnchor),
            title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            title.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            disclosureArrow.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            disclosureArrow.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            disclosureArrow.widthAnchor.constraint(equalToConstant: 20),
            disclosureArrow.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
    }
    
    public func configure(with option: SettingOption) {
        title.text = option.title
    }
    
    public func style() {
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.Palette.foreground
        self.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
