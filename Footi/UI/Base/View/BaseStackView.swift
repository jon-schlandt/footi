//
//  BaseStackView.swift
//  Footi
//
//  Created by Jon Schlandt on 7/4/23.
//

import UIKit

class BaseStackView: UIStackView {

    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.distribution = .fill
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
