//
//  StandingsTableHeader.swift
//  Footi
//
//  Created by Jon Schlandt on 4/10/23.
//

import UIKit

class StandingsTableHeader: UITableViewHeaderFooterView {

    static let identifier = String(describing: StandingsTableHeader.self)
    
    // MARK: Views
    
    private let background: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor.Palette.foreground
        
        return background
    }()
    
    private let container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        return container
    }()
    
    private let clubTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: FontConstants.standardSize, weight: .semibold)
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: AppConstants.baseMargin, bottom: 0, right: AppConstants.baseMargin)
        layout.itemSize = CGSize(width: 28, height: 52)
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.register(StandingStatTitleCell.self, forCellWithReuseIdentifier: StandingStatTitleCell.identifier)
        
        return view
    }()
    
    // MARK: Model
    
    var scrollDelegate: StandingsScrollViewDelegate?
    let statTitles = ["MP", "GF", "GA", "Pts", "W", "D", "L", "GD"]
    
    // MARK: Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundView = background
        self.contentView.addSubview(container)
        
        container.addSubview(clubTitleView)
        container.addSubview(separator)
        container.addSubview(statTitleView)
        
        statTitleView.dataSource = self
        statTitleView.delegate = self
        
        setStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            container.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: AppConstants.baseMargin)
        ])
        
        NSLayoutConstraint.activate([
            clubTitleView.widthAnchor.constraint(equalToConstant: 194),
            clubTitleView.topAnchor.constraint(equalTo: container.topAnchor),
            clubTitleView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            clubTitleView.leadingAnchor.constraint(equalTo: container.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: AppConstants.baseBorderWidth),
            separator.topAnchor.constraint(equalTo: container.topAnchor),
            separator.leadingAnchor.constraint(equalTo: clubTitleView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: statTitleView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            statTitleView.topAnchor.constraint(equalTo: container.topAnchor),
            statTitleView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            statTitleView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            statTitleView.leadingAnchor.constraint(equalTo: separator.trailingAnchor)
        ])
    }
}

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
        scrollDelegate?.setScroll(originatingView: scrollView, offset: scrollView.contentOffset)
        
        if scrollView.contentOffset.x > 0 {
            separator.backgroundColor = UIColor.Palette.border
        } else {
            separator.backgroundColor = .clear
        }
    }
}

/// Private methods
extension StandingsTableHeader {
    
    private func setStyling() {
        self.addBorders(edges: [.bottom], color: UIColor.Palette.border!)
    }
}
