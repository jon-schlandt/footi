//
//  InPlayIndicator.swift
//  Footi
//
//  Created by Jon Schlandt on 6/21/23.
//

import UIKit

class InPlayIndicator: UIView {

    // MARK: View
    
    private let indicatorLight: UIView = {
        let light = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        light.layer.cornerRadius = 5 / 2
        light.backgroundColor = UIColor.Palette.emphasisIcon
        
        return light
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicatorLight)
        
        startAnimation()
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    
    public func startAnimation() {
        UIView.animate(withDuration: 1.5, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            let newX = 20 - self.indicatorLight.bounds.width
            self.indicatorLight.frame.origin.x = newX
        }, completion: nil)
    }
}

/// Private methods
extension InPlayIndicator {
    
    private func setStyling() {
        self.layer.cornerRadius = 5 / 2
        self.clipsToBounds = true
        self.backgroundColor = UIColor.Palette.secondaryBackground
    }
}
