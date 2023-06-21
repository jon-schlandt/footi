//
//  BaseTableHeader.swift
//  Footi
//
//  Created by Jon Schlandt on 6/10/23.
//

import UIKit

class BaseTableHeader: UITableViewHeaderFooterView {

    // MARK: View
    
    private let background: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor.Palette.foreground
        
        return background
    }()
    
    internal let container: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        
        return view
    }()
    
    private let sectionSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.Palette.primaryBackground
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: AppConstants.baseSectionSpacing)
        ])
        
        return view
    }()
    
    // MARK: Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundView = background
        
        container.addArrangedSubview(sectionSpacer)
        self.contentView.addSubview(container)
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            container.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor)
        ])
    }
}

/// Private methods
extension BaseTableHeader {
    
    private func setStyling() {
        _ = self.contentView.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
