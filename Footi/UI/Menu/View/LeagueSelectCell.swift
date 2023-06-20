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
    
    private let leagueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private var leagueImage: UIImage!
    
    private let checkmark: UIImageView = {
        let checkmark = UIImageView()
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.contentMode = .scaleAspectFit
        checkmark.image = UIImage(systemName: "checkmark.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16.0, weight: .medium, scale: .medium))
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
        
        self.contentView.addSubview(leagueButton)
        self.contentView.addSubview(checkmark)
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
            leagueButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -56),
            leagueButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -56)
        ])
        
        NSLayoutConstraint.activate([
            checkmark.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: AppConstants.baseMargin),
            checkmark.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -AppConstants.baseMargin)
        ])
    }
    
    // MARK: Public
    
    public func configure(with selection: LeagueSelection) {
        self.selection = selection
        
        let leagueImage = UIImage(named: String(self.selection.id))
        leagueButton.setImage(leagueImage, for: .normal)
        leagueButton.addTarget(self, action: #selector(selectLeague), for: .touchUpInside)
        
        if selection.isEnabled == true {
            checkmark.isHidden = false
        } else {
            checkmark.isHidden = true
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
