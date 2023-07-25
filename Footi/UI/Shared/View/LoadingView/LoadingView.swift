//
//  LoadingView.swift
//  Footi
//
//  Created by Jon Schlandt on 7/15/23.
//

import Foundation
import UIKit

class LoadingView: UIView {
    
    // MARK: Subviews
    
    private let container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 16.0
        container.layer.borderWidth = AppConstants.baseBorderWidth
        container.layer.borderColor = UIColor.Palette.border?.cgColor
        container.backgroundColor = UIColor.Palette.foreground
        
        return container
    }()
    
    private let loadingWheel: LoadingWheel = {
        let wheel = LoadingWheel()
        wheel.layer.zPosition = 1
        
        return wheel
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(loadingWheel)
        self.addSubview(container)
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 144.0),
            container.heightAnchor.constraint(equalToConstant: 144.0),
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadingWheel.widthAnchor.constraint(equalToConstant: 48),
            loadingWheel.heightAnchor.constraint(equalToConstant: 48),
            loadingWheel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            loadingWheel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
    
    // MARK: Public methods
    
    public func beginAnimation() {
        let fullRotation = CABasicAnimation(keyPath: "transform.rotation")
        fullRotation.fromValue = 0
        fullRotation.toValue = Double.pi * 2
        fullRotation.duration = 1.0
        fullRotation.repeatCount = Float.greatestFiniteMagnitude
        fullRotation.isCumulative = true
        fullRotation.isRemovedOnCompletion = false

        loadingWheel.layer.add(fullRotation, forKey: "fullRotation")
    }
    
    public func endAnimation() {
        loadingWheel.layer.removeAllAnimations()
    }
}

// MARK: Private helpers

extension LoadingView {
    
    private func setStyling() {
        self.backgroundColor = UIColor.Palette.primaryBackground
    }
}
