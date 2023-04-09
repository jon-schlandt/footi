//
//  LeagueSelectStackView.swift
//  Footi
//
//  Created by Jon Schlandt on 3/25/23.
//

import UIKit

/// UIStackView methods
class LeagueSelectStackView: UIStackView {
    
    let header: UIView = {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        title.text = "League Select"
        header.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            title.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            title.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
        
        return header
    }()
    
    var leagueSelect: UIView!
    
    init(leagueSelect: UIView) {
        super.init(frame: .zero)
        
        self.leagueSelect = leagueSelect
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.distribution = .equalSpacing
        self.alignment = .center
        
        self.addArrangedSubview(header)
        self.addArrangedSubview(leagueSelect)
        
        style()
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalTo: self.widthAnchor),
            header.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            leagueSelect.widthAnchor.constraint(equalTo: self.widthAnchor),
            leagueSelect.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: (2 / 3)),
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// Private methods
extension LeagueSelectStackView {
    
    private func style() {
        self.backgroundColor = UIColor.Palette.foreground
    }
}
