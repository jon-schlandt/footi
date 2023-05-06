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
    
    let selectionLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        return title
    }()
    
    let dropdownIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "chevron.down")
        image.tintColor = UIColor.Palette.secondaryIcon
        
        return image
    }()
    
    // MARK: Model
    
    weak var delegate: LeagueDataFilterDropdownDelegate?
    var options: [DataFilterOption]! { didSet { setSelectionLabel(using: options) }}
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        self.spacing = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentFilter))
        self.addGestureRecognizer(tapGesture)
        
        self.addArrangedSubview(selectionLabel)
        self.addArrangedSubview(dropdownIcon)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            dropdownIcon.widthAnchor.constraint(equalToConstant: 15),
            dropdownIcon.heightAnchor.constraint(equalToConstant: 15)
        ])
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
