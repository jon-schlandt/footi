//
//  InPlayIndicator.swift
//  Footi
//
//  Created by Jon Schlandt on 6/21/23.
//

import UIKit

class InPlayIndicator: UIView {
    
    // Dimensions
    
    static private let width = 20.0
    static private let height = 5.0
    
    // Animation
    
    static private let animationDistance: CGFloat = width - height
    static private let animationDuration: TimeInterval = 1.20
    static private var currentOrigin = 0.0
    static private var animationStartTime: CFTimeInterval = 0.0
    
    static private var shouldMoveForward = true
    static private var hasLeader = false

    // MARK: Subviews
    
    private let indicatorLight: UIView = {
        let light = UIView(frame: CGRect(x: 0.0, y: 0.0, width: InPlayIndicator.height, height: InPlayIndicator.height))
        light.layer.cornerRadius = InPlayIndicator.height / 2
        light.backgroundColor = UIColor.Palette.emphasisIcon
        
        return light
    }()
    
    // MARK: Model
    
    var displayLink: CADisplayLink!
    var isAnimating = false
    var isLeader = false
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicatorLight)
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        InPlayIndicator.currentOrigin = 0.0
        InPlayIndicator.animationStartTime = 0.0
        InPlayIndicator.shouldMoveForward = true
        InPlayIndicator.hasLeader = false
    }
    
    // MARK: Public methods
    
    public func beginAnimation() {
        isAnimating = true
        
        displayLink = CADisplayLink(target: self, selector: #selector(moveIndicator(_:)))
        displayLink.add(to: .main, forMode: .common)
        
        if !InPlayIndicator.hasLeader {
            InPlayIndicator.hasLeader = true
            isLeader = true
            
            InPlayIndicator.animationStartTime = CACurrentMediaTime()
        }
    }
    
    public func initialize() {
        if isAnimating {
            displayLink.invalidate()
            indicatorLight.frame.origin.x = 0.0
            
            isAnimating = false
            InPlayIndicator.hasLeader = false
            isLeader = false
        }
    }
}

// MARK: Private helpers

extension InPlayIndicator {
    
    private func setStyling() {
        self.layer.cornerRadius = 5 / 2
        self.clipsToBounds = true
        self.backgroundColor = UIColor.Palette.secondaryBackground
    }
    
    // MARK: objc
    
    @objc private func moveIndicator(_ displayLink: CADisplayLink) {
        if !InPlayIndicator.hasLeader {
            InPlayIndicator.hasLeader = true
            isLeader = true
        }
        
        if isLeader {
            let elapsedTime = CACurrentMediaTime() - InPlayIndicator.animationStartTime
            let progress = elapsedTime / InPlayIndicator.animationDuration
            
            if progress >= 1.0 {
                InPlayIndicator.shouldMoveForward.toggle()
                InPlayIndicator.animationStartTime = CACurrentMediaTime()
                
                return
            }
            
            let animationProgress = InPlayIndicator.shouldMoveForward ? progress : 1.0 - progress
            InPlayIndicator.currentOrigin = InPlayIndicator.animationDistance * animationProgress
        }
        
        indicatorLight.frame.origin.x = InPlayIndicator.currentOrigin
    }
}
