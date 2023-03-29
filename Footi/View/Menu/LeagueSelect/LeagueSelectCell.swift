//
//  LeagueSelectCell.swift
//  Footi
//
//  Created by Jon Schlandt on 3/25/23.
//

import UIKit

protocol LeagueSelectCellDelegate: AnyObject {
    func selectLeague(_ league: String)
}

class LeagueSelectCell: UICollectionViewCell {
    
    static let identifier = "LeagueSelectCell"
    
    weak var delegate: LeagueSelectCellDelegate?
    var league: String!
    
    func loadLeagueButton() {
        let leagueImage = UIImage(named: league)?.withAlignmentRectInsets(UIEdgeInsets(top: -12, left: -12, bottom: -12, right: -12))
        
        let leagueButton = UIButton()
        leagueButton.translatesAutoresizingMaskIntoConstraints = false
        leagueButton.contentMode = .scaleAspectFit
        leagueButton.setImage(leagueImage, for: .normal)
        leagueButton.addTarget(self, action: #selector(selectLeague), for: .touchUpInside)
        self.addSubview(leagueButton)
        
        NSLayoutConstraint.activate([
            leagueButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            leagueButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            leagueButton.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -56),
            leagueButton.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -56)
        ])
    }
    
    func style(for indexPath: IndexPath) {
        self.addBorders(edges: [.bottom])
        self.backgroundColor = .systemBackground
        
        if indexPath.row % 3 == 1 {
            self.addBorders(edges: [.left, .right], offset: 20)
        }
    }
    
    @objc func selectLeague() {
        delegate?.selectLeague(league)
    }
}
