//
//  StandingsTableCell.swift
//  Footi
//
//  Created by Jon Schlandt on 4/9/23.
//

import UIKit

class StandingsTableCell: UITableViewCell {
    
    static let identifier = String(describing: StandingsTableCell.self)
    
    // MARK: Views
    
    private let container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        return container
    }()
    
    private let clubPositionView = ClubPositionStackView()
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    public var statsView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: 28, height: 54)
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.register(StandingStatCollectionCell.self, forCellWithReuseIdentifier: StandingStatCollectionCell.identifier)
        
        return view
    }()
    
    let matchesPlayedLabel = UILabel()
    let goalsForLabel = UILabel()
    let goalsAgainstLabel = UILabel()
    let pointsLabel = UILabel()
    let winsLabel = UILabel()
    let drawsLabel = UILabel()
    let lossesLabel = UILabel()
    let goalDeficitLabel = UILabel()
    
    // MARK: Model
    
    var scrollDelegate: StandingsScrollViewDelegate?
    var stats = [String]()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(container)
        
        container.addSubview(clubPositionView)
        container.addSubview(separator)
        container.addSubview(statsView)

        statsView.dataSource = self
        statsView.delegate = self
                
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            clubPositionView.widthAnchor.constraint(equalToConstant: 194),
            clubPositionView.topAnchor.constraint(equalTo: container.topAnchor),
            clubPositionView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            clubPositionView.leadingAnchor.constraint(equalTo: container.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: 1),
            separator.topAnchor.constraint(equalTo: container.topAnchor),
            separator.trailingAnchor.constraint(equalTo: statsView.leadingAnchor),
            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: clubPositionView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            statsView.topAnchor.constraint(equalTo: container.topAnchor),
            statsView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            statsView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            statsView.leadingAnchor.constraint(equalTo: separator.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        stats.removeAll()
        
        clubPositionView.positionLabel.text = nil
        clubPositionView.clubBadge.image = nil
        clubPositionView.clubTitle.text = nil
        
        let statLabels = [matchesPlayedLabel, goalsForLabel, goalsAgainstLabel, pointsLabel, winsLabel, drawsLabel, lossesLabel, goalDeficitLabel]
        statLabels.forEach { $0.text = nil }
    }
    
    // MARK: Public
    
    public func configure(with standing: ClubStanding) {
        clubPositionView.positionLabel.text = String(standing.position)
        clubPositionView.clubBadge.load(url: URL(string: standing.clubBadgeUrl)!)
        clubPositionView.clubTitle.text = standing.clubTitle
        
        stats.append(String(standing.matchesPlayed))
        stats.append(String(standing.goalsFor))
        stats.append(String(standing.goalsAgainst))
        stats.append(String(standing.points))
        stats.append(String(standing.wins))
        stats.append(String(standing.draws))
        stats.append(String(standing.losses))
        stats.append(String(standing.goalDeficit))
        
        statsView.reloadData()
    }
}

extension StandingsTableCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandingStatCollectionCell.identifier, for: indexPath) as! StandingStatCollectionCell
        let stat = stats[indexPath.row]
        
        if indexPath.row == 3 {
            cell.statLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
        
        cell.statLabel.text = stat
        return cell
    }
}

extension StandingsTableCell: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.setScroll(originatingView: scrollView, offset: scrollView.contentOffset)
        
        if scrollView.contentOffset.x > 0 {
            separator.backgroundColor = UIColor.Palette.border
        } else {
            separator.backgroundColor = .clear
        }
    }
}

/// Private methods
extension StandingsTableCell {
    
    private func setStyling() {
        self.contentView.backgroundColor = UIColor.Palette.foreground
        self.contentView.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
