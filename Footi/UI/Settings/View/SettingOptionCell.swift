//
//  SettingsOptionCell.swift
//  Footi
//
//  Created by Jon Schlandt on 3/28/23.
//

import UIKit

class SettingOptionCell: BaseTableCell {

    static let identifier = String(describing: SettingOptionCell.self)
    
    // MARK: View
    
    private let container: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        
        return view
    }()
    
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontConstants.paragraph, size: FontConstants.standardSize)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    private let disclosureView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 4
        
        return view
    }()
    
    private let selectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontConstants.title, size: FontConstants.extraSmallSize)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    private let disclosureArrow: UIImageView = {
        let disclosureArrow = UIImageView()
        disclosureArrow.translatesAutoresizingMaskIntoConstraints = false
        disclosureArrow.contentMode = .scaleAspectFit
        disclosureArrow.tintColor = UIColor.Palette.secondaryIcon
        disclosureArrow.image = UIImage(systemName: "chevron.right")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 10.0, weight: .light, scale: .medium))
        
        return disclosureArrow
    }()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        disclosureView.addArrangedSubview(selectionLabel)
        disclosureView.addArrangedSubview(disclosureArrow)
        
        container.addArrangedSubview(optionLabel)
        container.addArrangedSubview(disclosureView)
        self.contentView.addSubview(container)
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            container.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -AppConstants.baseMargin),
            container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: AppConstants.baseMargin)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        optionLabel.text = nil
        selectionLabel.text = nil
    }
    
    // MARK: Public
    
    public func configure(with option: SettingOption, isLast: Bool) {
        super.configure(isLast: isLast)
        
        optionLabel.text = option.title
        selectionLabel.text = option.selections.first { $0.isEnabled ?? false }?.title
    }
}

/// Private methods
extension SettingOptionCell {
    
    private func setStyling() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.Palette.foreground
    }
}
