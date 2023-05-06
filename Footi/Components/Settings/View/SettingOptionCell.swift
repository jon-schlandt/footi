//
//  SettingsOptionCell.swift
//  Footi
//
//  Created by Jon Schlandt on 3/28/23.
//

import UIKit

class SettingOptionCell: UITableViewCell {

    static let identifier = String(describing: SettingOptionCell.self)
    
    // MARK: Views
    
    private let label: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = UIColor.Palette.secondaryText
        
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
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(disclosureArrow)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: disclosureArrow.leadingAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            disclosureArrow.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            disclosureArrow.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            disclosureArrow.widthAnchor.constraint(equalToConstant: 18),
            disclosureArrow.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    public func configure(with option: SettingOption) {
        label.text = option.title
    }
    
    public func style() {
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.Palette.foreground
        self.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
