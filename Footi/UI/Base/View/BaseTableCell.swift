//
//  BaseTableCell.swift
//  Footi
//
//  Created by Jon Schlandt on 6/20/23.
//

import UIKit

class BaseTableCell: UITableViewCell {
    
    // MARK: Subviews
    
    internal var border: UIView!

    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        border.removeFromSuperview()
    }
    
    // MARK: Public methods
    
    public func configure(isLast: Bool) {
        if isLast {
            border = self.contentView.addBorders(edges: [.bottom], color: UIColor.Palette.border!).first!
        } else {
            border = self.contentView.addBorders(edges: [.bottom], color: UIColor.Palette.border!, lOffset: AppConstants.baseMargin).first!
        }
    }
}

// MARK: Helper methods

extension BaseTableCell {
    
    private func setStyling() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.Palette.foreground
    }
}
