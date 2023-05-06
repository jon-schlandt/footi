//
//  ClubPositionStackView.swift
//  Footi
//
//  Created by Jon Schlandt on 4/24/23.
//

import UIKit

class ClubPositionStackView: UIStackView {
    
    // MARK: Views
    
    let positionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let positionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.Palette.primaryText
        
        return label
    }()
    
    let clubView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 10
        
        return view
    }()
    
    let clubBadge: UIImageView = {
        let badge = UIImageView()
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            badge.widthAnchor.constraint(equalToConstant: 18),
            badge.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        return badge
    }()
    
    let clubTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = UIColor.Palette.primaryText
        
        return title
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        self.spacing = 10
        
        positionView.addSubview(positionLabel)
        clubView.addArrangedSubview(clubBadge)
        clubView.addArrangedSubview(clubTitle)
        
        [positionView, clubView].forEach { item in
            self.addArrangedSubview(item)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            positionView.widthAnchor.constraint(equalToConstant: 18),
            positionLabel.centerXAnchor.constraint(equalTo: positionView.centerXAnchor),
            positionLabel.centerYAnchor.constraint(equalTo: positionView.centerYAnchor)
        ])
    }
}
