//
//  BaseTableCell.swift
//  Footi
//
//  Created by Jon Schlandt on 6/20/23.
//

import UIKit

class BaseTableCell: UITableViewCell {
    
    // MARK: View
    
    internal var border: UIView!

    // MARK: Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        border.removeFromSuperview()
    }
    
    // MARK: Internal
    
    public func configure(isLast: Bool) {
        if isLast {
            border = self.contentView.addBorders(edges: [.bottom], color: UIColor.Palette.border!).first!
        } else {
            border = self.contentView.addBorders(edges: [.bottom], color: UIColor.Palette.border!, lOffset: AppConstants.baseMargin).first!
        }
    }
}
