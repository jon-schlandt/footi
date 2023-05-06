//
//  LeagueDataFilterTableCell.swift
//  Footi
//
//  Created by Jon Schlandt on 4/17/23.
//

import UIKit

class LeagueDataFilterTableCell: UITableViewCell {
    
    static let identifier = String(describing: LeagueDataFilterTableCell.self)
    
    // MARK: Views
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private let checkmark: UIImageView = {
        let checkmark = UIImageView()
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.contentMode = .scaleAspectFit
        checkmark.tintColor = UIColor.Palette.secondaryIcon
        checkmark.image = UIImage(systemName: "circle")
        
        return checkmark
    }()
    
    // MARK: Model
    
    var value: Int!
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        value = nil
        label.text = nil
        checkmark.image = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .light))
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: checkmark.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkmark.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            checkmark.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 20),
            checkmark.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: Public
    
    public func configure(with option: DataFilterOption) {
        value = option.value
        isEnabled = option.isEnabled
        
        label.text = option.displayName
        
        if option.isEnabled {
            checkmark.image = UIImage(systemName: "circle.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))
        } else {
            checkmark.image = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .light))
        }
    }
}

/// Private methods
extension LeagueDataFilterTableCell {
    
    private func style() {
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.Palette.foreground
        self.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
