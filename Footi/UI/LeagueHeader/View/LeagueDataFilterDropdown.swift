//
//  LeagueDataFilterDropdown.swift
//  Footi
//
//  Created by Jon Schlandt on 4/13/23.
//

import UIKit

protocol LeagueDataFilterDropdownDelegate: AnyObject {
    func presentFilter()
}

class LeagueDataFilterDropdown: UIStackView {
    
    // MARK: Views
    
    private let selectionLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: FontConstants.title, size: FontConstants.standardSize)
        title.textColor = UIColor.Palette.primaryText
        
        return title
    }()
    
    private let dropdownIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "chevron.down")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 8.0, weight: .light, scale: .medium))
        image.tintColor = UIColor.Palette.secondaryIcon
        
        return image
    }()
    
    // MARK: Model
    
    public weak var delegate: LeagueDataFilterDropdownDelegate?
    private var options: [DataFilterOption]! { didSet { setSelectionLabel(using: options) }}
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        self.spacing = 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentFilter))
        self.addGestureRecognizer(tapGesture)
        
        self.addArrangedSubview(selectionLabel)
        self.addArrangedSubview(dropdownIcon)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    
    public func configure(with options: [DataFilterOption]) {
        self.options = options
    }
}

/// Private methods
extension LeagueDataFilterDropdown {
    
    private func setSelectionLabel(using options: [DataFilterOption]) {
        let selected = options.first { $0.isEnabled == true }
        if let selected = selected {
            selectionLabel.text = selected.displayName
        }
    }
    
    @objc private func presentFilter() {
        delegate?.presentFilter()
    }
}
