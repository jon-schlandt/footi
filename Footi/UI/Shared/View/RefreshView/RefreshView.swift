//
//  LoadingView.swift
//  Footi
//
//  Created by Jon Schlandt on 7/2/23.
//

import Foundation
import UIKit

class RefreshView: UIView {
    
    // MARK: Subviews
    
    public let wheel: UIImageView = {
        let wheel = UIImageView()
        wheel.translatesAutoresizingMaskIntoConstraints = false
        wheel.contentMode = .center
        wheel.image = UIImage(systemName: "arrow.triangle.2.circlepath")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18.0, weight: .medium, scale: .medium))
        wheel.tintColor = UIColor.Palette.tertiarySymbol
        
        return wheel
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        
        self.addSubview(wheel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            wheel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            wheel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // MARK: Public methods
    
    public func beginAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 1.25
        animation.repeatCount = .infinity
        
        wheel.layer.add(animation, forKey: "animation")
    }
    
    public func endAnimation() {
        wheel.layer.removeAllAnimations()
    }
}
