//
//  LeagueSelectStackView.swift
//  Footi
//
//  Created by Jon Schlandt on 3/25/23.
//

import UIKit

/// UIStackView methods
class LeagueSelectStackView: UIStackView {

    var header: LeagueSelectHeader!
    var leagueSelect: UIView!
    
    init(leagueSelectView: UIView) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupHeader()
        setupLeagueSelect(leagueSelectView: leagueSelectView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// Private methods
extension LeagueSelectStackView {
    
    private func setupHeader() {
        header = LeagueSelectHeader()
        self.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: self.topAnchor),
            header.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            header.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupLeagueSelect(leagueSelectView: UIView) {
        leagueSelect = leagueSelectView
        self.addSubview(leagueSelectView)
        
        NSLayoutConstraint.activate([
            leagueSelect.topAnchor.constraint(equalTo: header.bottomAnchor),
            leagueSelect.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            leagueSelect.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor),
            leagueSelect.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
}
