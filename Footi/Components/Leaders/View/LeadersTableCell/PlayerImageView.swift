//
//  PlayerImageView.swift
//  Footi
//
//  Created by Jon Schlandt on 6/1/23.
//

import UIKit

class PlayerImageView: UIView {

    // MARK: Subviews
    
    public let playerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(playerImage)
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 38),
            self.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            playerImage.widthAnchor.constraint(equalToConstant: 28),
            playerImage.heightAnchor.constraint(equalToConstant: 28),
            playerImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playerImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        playerImage.layer.cornerRadius = playerImage.frame.size.width / 2
        playerImage.layer.masksToBounds = true
    }
}

// MARK: Helper methods

extension PlayerImageView {
    
    private func setStyling() {
        self.layer.borderWidth = AppConstants.baseBorderWidth
        self.layer.borderColor = UIColor.Palette.primaryBorder?.cgColor
    }
}
