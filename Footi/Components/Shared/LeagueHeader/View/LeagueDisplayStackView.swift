//
//  LeagueDisplayStackView.swift
//  Footi
//
//  Created by Jon Schlandt on 4/13/23.
//

import UIKit

class LeagueDisplayStackView: UIStackView {
    
    // MARK: Views

    let leagueLogo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    let leagueTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        return title
    }()
    
    let separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.Palette.border
        separator.isHidden = true
        
        return separator
    }()
    
    let liveImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "live")
        image.isHidden = true
        
        return image
    }()
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        self.spacing = 10
        
        self.addArrangedSubview(leagueLogo)
        self.addArrangedSubview(leagueTitle)
        self.addArrangedSubview(separator)
        self.addArrangedSubview(liveImage)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            leagueLogo.widthAnchor.constraint(equalToConstant: 24),
            leagueLogo.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: 1),
            separator.topAnchor.constraint(equalTo: self.topAnchor, constant: 17),
            separator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -17)
        ])
        
        NSLayoutConstraint.activate([
            liveImage.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
}
