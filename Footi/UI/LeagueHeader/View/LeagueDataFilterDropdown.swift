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
    
    // MARK: Subviews
    
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
        image.image = UIImage(systemName: "chevron.down")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 7.0, weight: .light, scale: .medium))
        image.tintColor = UIColor.Palette.secondaryIcon
        
        return image
    }()
    
    // MARK: Model
    
    private var options: [DataFilterOption]! { didSet { setSelectionLabel(using: options) }}
    public weak var delegate: LeagueDataFilterDropdownDelegate?
    
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
    
    // MARK: Public methods
    
    public func configure(with options: [DataFilterOption]) {
        self.options = options
    }
    
    public func resetDropdown() {
        UIView.animate(withDuration: 0.20) {
            self.dropdownIcon.transform = .identity
        }
    }
}

// MARK: Private helpers

extension LeagueDataFilterDropdown {
    
    private func setSelectionLabel(using options: [DataFilterOption]) {
        let selected = options.first { $0.isEnabled == true }
        if let selected = selected {
            selectionLabel.text = selected.displayName
        }
    }
    
    @objc private func presentFilter() {
        UIView.animate(withDuration: 0.20) {
            self.dropdownIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2) // Rotate 45 degrees (π/4 radians)
        }
        
        delegate?.presentFilter()
    }
}
