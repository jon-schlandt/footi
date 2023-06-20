//
//  StandingsTableCell.swift
//  Footi
//
//  Created by Jon Schlandt on 4/9/23.
//

import UIKit

class StandingsTableCell: BaseTableCell {
    
    static let identifier = String(describing: StandingsTableCell.self)
    
    // MARK: View
    
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: AppConstants.baseMargin, bottom: 0, right: AppConstants.baseMargin)
        layout.itemSize = CGSize(width: 28, height: 54)
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.register(StandingStatCollectionCell.self, forCellWithReuseIdentifier: StandingStatCollectionCell.identifier)
        
        return view
    }()
    
    private let matchesPlayedLabel = UILabel()
    private let goalsForLabel = UILabel()
    private let goalsAgainstLabel = UILabel()
    private let pointsLabel = UILabel()
    private let winsLabel = UILabel()
    private let drawsLabel = UILabel()
    private let lossesLabel = UILabel()
    private let goalDeficitLabel = UILabel()
    
    // MARK: Model
    
    public weak var scrollDelegate: StandingsScrollViewDelegate?
    public var stats = [String]()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(container)
        
        container.addSubview(clubPositionView)
        container.addSubview(separator)
        container.addSubview(statsView)
        
        NSLayoutConstraint.activate([
            statsView.topAnchor.constraint(equalTo: container.topAnchor),
            statsView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            statsView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            statsView.leadingAnchor.constraint(equalTo: separator.trailingAnchor)
        ])

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
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: AppConstants.baseMargin)
        ])
        
        NSLayoutConstraint.activate([
            clubPositionView.widthAnchor.constraint(equalToConstant: 194),
            clubPositionView.topAnchor.constraint(equalTo: container.topAnchor),
            clubPositionView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            clubPositionView.leadingAnchor.constraint(equalTo: container.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: AppConstants.baseBorderWidth),
            separator.topAnchor.constraint(equalTo: container.topAnchor),
            separator.trailingAnchor.constraint(equalTo: statsView.leadingAnchor),
            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: clubPositionView.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clubPositionView.initialize()
        
        stats.removeAll()
        [matchesPlayedLabel, goalsForLabel, goalsAgainstLabel, pointsLabel, winsLabel, drawsLabel, lossesLabel, goalDeficitLabel]
            .forEach { $0.text = nil }
    }
    
    // MARK: Public
    
    public func configure(with standing: Standing, isLast: Bool) {
        super.configure(isLast: isLast)
        
        clubPositionView.configure(with: standing)
    
        stats.append(String(standing.record.played))
        stats.append(String(standing.record.goals.scored))
        stats.append(String(standing.record.goals.conceded))
        stats.append(String(standing.points))
        stats.append(String(standing.record.won))
        stats.append(String(standing.record.drew))
        stats.append(String(standing.record.lost))
        stats.append(String(standing.goalDifference))
        
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
        
        cell.configure(stat: stat, index: indexPath.row)
        return cell
    }
}

extension StandingsTableCell: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == statsView else {
            return
        }

        scrollDelegate?.setScroll(originatingView: scrollView, offset: scrollView.contentOffset)
        setScrollBorder(using: scrollView.contentOffset)
    }
}

/// Private methods
extension StandingsTableCell {
    
    private func setStyling() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.Palette.foreground
    }
    
    private func setScrollBorder(using offset: CGPoint) {
        if offset.x > 0 {
            separator.backgroundColor = UIColor.Palette.border
        } else {
            separator.backgroundColor = .clear
        }
    }
}
