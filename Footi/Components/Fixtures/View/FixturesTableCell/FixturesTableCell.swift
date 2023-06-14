//
//  FixturesTableCell.swift
//  Footi
//
//  Created by Jon Schlandt on 5/8/23.
//

import UIKit

class FixturesTableCell: UITableViewCell {

    static let identifier = String(describing: FixturesTableHeader.self)
    
    // MARK: View
    
    private let container: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        
        return view
    }()
    
    private let matchupView = FixtureMatchupView()
    
    private let separatorView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.Palette.border
        container.addSubview(separator)
        
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: AppConstants.baseBorderWidth)
        ])
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: container.topAnchor, constant: AppConstants.baseMargin),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -AppConstants.baseMargin),
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor)
        ])
        
        return container
    }()
    
    private var statusView = UIView()
    
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        container.addArrangedSubview(matchupView)
        container.addArrangedSubview(separatorView)
        self.contentView.addSubview(container)
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
            container.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            statusView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: (1 / 3))
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        matchupView.initialize()
        
        container.removeArrangedSubview(statusView)
        statusView.removeFromSuperview()
    }
    
    // MARK: Public
    
    public func configure(with fixture: Fixture) {
        matchupView.configure(with: fixture)
        
        switch fixture.overview.status.type {
        case .finished:
            statusView = FinishedStatusView()
        case .inPlay:
            statusView = InPlayStatusView()
        case .upcoming:
            statusView = UpcomingStatusView()
        default:
            break
        }
        
        container.addArrangedSubview(statusView)
        
        if let statusView = statusView as? FixtureStatusView {
            statusView.configure(with: fixture)
        }
    }
}

/// Private methods
extension FixturesTableCell {
    
    private func setStyling() {
        self.selectionStyle = .none
        
        self.contentView.backgroundColor = UIColor.Palette.foreground
        self.contentView.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
