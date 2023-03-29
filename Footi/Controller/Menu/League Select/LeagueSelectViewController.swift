//
//  LeagueSelectViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/19/23.
//

import UIKit

protocol LeagueSelectViewControllerDelegate: AnyObject {
    func selectLeague(_ league: String)
}

/// UICollectionViewController methods
class LeagueSelectViewController: UICollectionViewController {
    
    var flowLayout: UICollectionViewFlowLayout!
    weak var delegate: LeagueSelectViewControllerDelegate?
    
    let userDefaultsContext = UserDefaultsContext()
    let leagues = [ "bundesliga", "laLiga", "ligue1", "mls", "premierLeague", "serieA" ]
    
    init() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        super.init(collectionViewLayout: flowLayout)
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(LeagueSelectCell.self, forCellWithReuseIdentifier: LeagueSelectCell.identifier)
        styleView()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LeagueSelectCell.identifier, for: indexPath) as! LeagueSelectCell
        cell.delegate = self
        cell.league = leagues[indexPath.row]
        cell.loadLeagueButton()
        cell.style(for: indexPath)
        
        return cell
    }
}

/// LeagueSelectCellDelegate methods
extension LeagueSelectViewController: LeagueSelectCellDelegate {
    
    internal func selectLeague(_ league: String) {
        userDefaultsContext.setSelectedLeague(as: league)
        delegate?.selectLeague(league)
    }
}

/// UICollectionViewDelegateFlowLayout methods
extension LeagueSelectViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = self.flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        
        return CGSize(width: itemDimension, height: itemDimension)
    }
}

/// Private methods
extension LeagueSelectViewController {
    
    private func styleView() {
        self.view.backgroundColor = .systemBackground
    }
}
