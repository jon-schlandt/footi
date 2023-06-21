//
//  LeagueSelectCell.swift
//  Footi
//
//  Created by Jon Schlandt on 3/25/23.
//

import UIKit

protocol LeagueSelectCellDelegate: AnyObject {
    func selectLeague(_ leagueKey: String)
}

class LeagueSelectCell: UICollectionViewCell {
    
    public static let identifier = String(describing: LeagueSelectCell.self)
    
    // MARK: Views
    
    private let leagueButton: UIView = {
        let button = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        
        return button
    }()
    
    private var leagueImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private let checkmark: UIImageView = {
        let checkmark = UIImageView()
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.contentMode = .scaleAspectFit
        checkmark.image = UIImage(systemName: "checkmark.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12.0, weight: .medium, scale: .medium))
        checkmark.tintColor = UIColor.Palette.emphasisIcon
        checkmark.isHidden = true
        
        return checkmark
    }()
    
    // MARK: Model
    
    public weak var delegate: LeagueSelectCellDelegate?
    private var selection: LeagueSelection!
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leagueButton.addSubview(leagueImage)
        leagueButton.addSubview(checkmark)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectLeague))
        leagueButton.addGestureRecognizer(tapGesture)
        
        self.contentView.addSubview(leagueButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        selection = nil
        checkmark.isHidden = true
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            leagueButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            leagueButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            leagueButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -40),
            leagueButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            leagueImage.centerXAnchor.constraint(equalTo: leagueButton.centerXAnchor),
            leagueImage.centerYAnchor.constraint(equalTo: leagueButton.centerYAnchor),
            leagueImage.widthAnchor.constraint(equalTo: leagueButton.widthAnchor, multiplier: 1 / 2),
            leagueImage.heightAnchor.constraint(equalTo: leagueButton.heightAnchor, multiplier: 1 / 2)
        ])
        
        NSLayoutConstraint.activate([
            checkmark.topAnchor.constraint(equalTo: leagueButton.topAnchor, constant: 8),
            checkmark.trailingAnchor.constraint(equalTo: leagueButton.trailingAnchor, constant: -8)
        ])
    }
    
    // MARK: Public
    
    public func configure(with selection: LeagueSelection) {
        self.selection = selection
        
        leagueImage.image = UIImage(named: String(self.selection.id))
        
        if selection.isEnabled == true {
            checkmark.isHidden = false
            leagueButton.backgroundColor = UIColor.Palette.secondaryBackground
        } else {
            checkmark.isHidden = true
            leagueButton.backgroundColor = .clear
        }
    }
    
    public func style(for index: Int) {
        _ = self.contentView.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
        
        if index % 3 == 1 {
            _ = self.contentView.addBorders(edges: [.left, .right], color: UIColor.Palette.border!, lOffset: 20, rOffset: 20)
        }
    }
}

/// Private methods
extension LeagueSelectCell {
    
    @objc private func selectLeague() {
        delegate?.selectLeague(selection.key)
    }
}
