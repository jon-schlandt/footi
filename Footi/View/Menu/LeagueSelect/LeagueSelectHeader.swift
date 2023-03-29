//
//  LeagueSelectHeader.swift
//  Footi
//
//  Created by Jon Schlandt on 3/24/23.
//

import UIKit

class LeagueSelectHeader: UIView {

    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addBorders(edges: [.bottom])
        
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "League Select"
        title.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        self.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 19),
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
