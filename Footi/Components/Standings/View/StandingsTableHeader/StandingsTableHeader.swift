//
//  StandingsTableHeader.swift
//  Footi
//
//  Created by Jon Schlandt on 4/10/23.
//

import UIKit

class StandingsTableHeader: BaseTableHeader {

    public static let identifier = String(describing: StandingsTableHeader.self)
    
    // MARK: Subviews
    
    private let standingsTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let clubTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.title, size: FontConstants.standardSize)
        label.textColor = UIColor.Palette.tertiaryText
        label.text = "Club"
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    public let statTitleView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: AppConstants.baseMargin / 2, bottom: 0, right: AppConstants.baseMargin)
        layout.itemSize = CGSize(width: 28, height: 52)
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.register(StandingStatTitleCell.self, forCellWithReuseIdentifier: StandingStatTitleCell.identifier)
        view.backgroundColor = .clear
        
        return view
    }()
    
    // MARK: Model
    
    private let statTitles = ["MP", "GD", "Pts", "W", "D", "L", "GF", "GA"]
    public weak var scrollDelegate: StandingsScrollViewDelegate?
    
    // MARK: Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        standingsTitleView.addSubview(clubTitleView)
        standingsTitleView.addSubview(separator)
        standingsTitleView.addSubview(statTitleView)
        self.content.addSubview(standingsTitleView)
        
        statTitleView.dataSource = self
        statTitleView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            standingsTitleView.topAnchor.constraint(equalTo: self.content.topAnchor),
            standingsTitleView.trailingAnchor.constraint(equalTo: self.content.trailingAnchor),
            standingsTitleView.bottomAnchor.constraint(equalTo: self.content.bottomAnchor),
            standingsTitleView.leadingAnchor.constraint(equalTo: self.content.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            clubTitleView.widthAnchor.constraint(equalToConstant: 200),
            clubTitleView.topAnchor.constraint(equalTo: standingsTitleView.topAnchor),
            clubTitleView.bottomAnchor.constraint(equalTo: standingsTitleView.bottomAnchor),
            clubTitleView.leadingAnchor.constraint(equalTo: standingsTitleView.leadingAnchor, constant: AppConstants.baseMargin)
        ])
        
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: AppConstants.baseBorderWidth),
            separator.topAnchor.constraint(equalTo: standingsTitleView.topAnchor),
            separator.leadingAnchor.constraint(equalTo: clubTitleView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: standingsTitleView.bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: statTitleView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            statTitleView.topAnchor.constraint(equalTo: standingsTitleView.topAnchor),
            statTitleView.trailingAnchor.constraint(equalTo: standingsTitleView.trailingAnchor),
            statTitleView.bottomAnchor.constraint(equalTo: standingsTitleView.bottomAnchor),
            statTitleView.leadingAnchor.constraint(equalTo: separator.trailingAnchor)
        ])
    }
}

// MARK: UICollectionView

extension StandingsTableHeader: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        statTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandingStatTitleCell.identifier, for: indexPath) as! StandingStatTitleCell
        let title = statTitles[indexPath.row]
        
        cell.statTitle.text = title
        return cell
    }
}

extension StandingsTableHeader: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.setStatsOffset(originatingView: scrollView, offset: scrollView.contentOffset)
        
        if scrollView.contentOffset.x > 0 {
            separator.backgroundColor = UIColor.Palette.primaryBorder
        } else {
            separator.backgroundColor = .clear
        }
    }
}
