//
//  BaseTitleView.swift
//  Footi
//
//  Created by Jon Schlandt on 7/19/23.
//

import UIKit

class BaseTitleView: UIView {

    // MARK: Subviews
    
    private let container: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .horizontal
        container.alignment = .center
        container.distribution = .fill
        container.spacing = 8
        
        return container
    }()
    
    private let titleIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = UIColor.Palette.primarySymbol
        
        return icon
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: FontConstants.title, size: FontConstants.extraLargeSize - 1)
        title.textColor = UIColor.Palette.barText
        
        return title
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        container.addArrangedSubview(titleIcon)
        container.addArrangedSubview(titleLabel)
        self.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods
    
    public func setTitle(as title: String) {
        titleLabel.text = title
    }
    
    public func setIcon(as icon: String) {
        titleIcon.image = UIImage(systemName: icon)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16.0 - 1, weight: .light, scale: .medium))
    }
}
