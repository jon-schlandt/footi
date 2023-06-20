//
//  SettingGroupHeader.swift
//  Footi
//
//  Created by Jon Schlandt on 3/29/23.
//

import UIKit

class SettingGroupHeader: UITableViewHeaderFooterView {

    static let identifier = String(describing: SettingGroupHeader.self)
    
    // MARK: View
    
    private let background: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = UIColor.Palette.foreground
        
        return background
    }()
    
    private let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "Inter-Regular_SemiBold", size: FontConstants.standardSize)
        
        return title
    }()
    
    // MARK: Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundView = background
        contentView.addSubview(title)
        
        setStyling()
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            background.widthAnchor.constraint(equalTo: self.widthAnchor),
            background.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: AppConstants.baseMargin),
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    
    public func configure(with group: SettingGroup) {
        title.text = group.title
    }
}

/// Private methods
extension SettingGroupHeader {
    
    private func setStyling() {
        _ = self.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
