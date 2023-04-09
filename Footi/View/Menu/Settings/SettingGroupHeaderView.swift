//
//  SettingGroupHeaderView.swift
//  Footi
//
//  Created by Jon Schlandt on 3/29/23.
//

import UIKit

class SettingGroupHeaderView: UITableViewHeaderFooterView {

    static let identifier = "SettingsHeaderView"
    
    private let background: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = UIColor.Palette.foreground
        
        return background
    }()
    
    private let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 1
        title.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        return title
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundView = background
        contentView.addSubview(title)
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            background.widthAnchor.constraint(equalTo: self.widthAnchor),
            background.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with group: SettingGroup) {
        title.text = group.title
    }
    
    public func style(for section: Int) {
        if (section != 0) {
            self.addBorders(edges: [.top], color: UIColor.Palette.border!)
        }
        
        self.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
