//
//  LeagueSelectCell.swift
//  Footi
//
//  Created by Jon Schlandt on 3/25/23.
//

import UIKit

protocol LeagueSelectCellDelegate: AnyObject {
    func selectLeague(_ leagueKey: LeagueKey)
}

/// UITableViewCell methods
class LeagueSelectCell: UICollectionViewCell {
    
    static let identifier = "LeagueSelectCell"
    weak var delegate: LeagueSelectCellDelegate?
    
    var league: LeagueSelection!
    
    let leagueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    var leagueImage: UIImage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(leagueButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            leagueButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            leagueButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            leagueButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -56),
            leagueButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -56)
        ])
    }
    
    public func configure(with league: LeagueSelection) {
        self.league = league
        
        let leagueImage = UIImage(named: self.league.key.rawValue)?.withAlignmentRectInsets(UIEdgeInsets(top: -12, left: -12, bottom: -12, right: -12))
        leagueButton.setImage(leagueImage, for: .normal)
        leagueButton.addTarget(self, action: #selector(selectLeague), for: .touchUpInside)
    }
    
    public func style(for indexPath: IndexPath) {
        self.contentView.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
        
        if indexPath.row % 3 == 1 {
            self.contentView.addBorders(edges: [.left, .right], color: UIColor.Palette.border!, offset: 20)
        }
    }
}

/// Private methods
extension LeagueSelectCell {
    
    @objc private func selectLeague() {
        delegate?.selectLeague(league.key)
    }
}
