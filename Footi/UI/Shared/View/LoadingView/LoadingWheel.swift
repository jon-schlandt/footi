//
//  LoadingWheel.swift
//  Footi
//
//  Created by Jon Schlandt on 7/15/23.
//

import UIKit

class LoadingWheel: UIView {
    
    // MARK: Subviews
    
    private let innerCutout: UIView = {
        let cutout = UIView()
        cutout.translatesAutoresizingMaskIntoConstraints = false
        cutout.backgroundColor = UIColor.Palette.foreground
        
        return cutout
        
    }()
    
    private let loadingIndicator: UIView = {
        let indicator = UIView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = UIColor.Palette.emphasis
        
        return indicator
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(innerCutout)
        self.addSubview(loadingIndicator)

        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            innerCutout.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -18.0),
            innerCutout.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -18.0),
            innerCutout.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            innerCutout.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadingIndicator.widthAnchor.constraint(equalToConstant: 9.0),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 9.0),
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        self.layer.cornerRadius = self.bounds.width / 2.0
        loadingIndicator.layer.cornerRadius = loadingIndicator.bounds.width / 2.0
        innerCutout.layer.cornerRadius = innerCutout.bounds.width / 2.0
        
        self.clipsToBounds = true
        innerCutout.clipsToBounds = true
        loadingIndicator.clipsToBounds = true
    }
}

// MARK: Private helpers

extension LoadingWheel {
    
    private func setStyling() {
        self.backgroundColor = UIColor.Palette.secondaryBackground
    }
}
