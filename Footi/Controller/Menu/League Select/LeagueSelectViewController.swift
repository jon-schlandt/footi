//
//  LeagueSelectViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/19/23.
//

import UIKit

struct LeagueSelection {
    var key: LeagueKey
    var title: String
}

protocol LeagueSelectViewControllerDelegate: AnyObject {
    func selectLeague()
}

/// UICollectionViewController methods
class LeagueSelectViewController: UICollectionViewController {
    
    var flowLayout: UICollectionViewFlowLayout!
    weak var delegate: LeagueSelectViewControllerDelegate?
    
    let userDefaultsContext = UserDefaultsContext()
    var selections = [LeagueSelection]()
    
    init() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(LeagueSelectCell.self, forCellWithReuseIdentifier: LeagueSelectCell.identifier)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        setSelections()
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
        cell.configure(with: selections[indexPath.row])
        cell.style(for: indexPath)
        
        return cell
    }
}

/// LeagueSelectCellDelegate methods
extension LeagueSelectViewController: LeagueSelectCellDelegate {
    
    internal func selectLeague(_ leagueKey: LeagueKey) {
        userDefaultsContext.setSelectedLeague(as: leagueKey.rawValue)
        delegate?.selectLeague()
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
    
    private func setSelections() {
        selections.append(LeagueSelection(key: .bundesliga, title: "Bundesliga"))
        selections.append(LeagueSelection(key: .laLiga, title: "LaLiga"))
        selections.append(LeagueSelection(key: .ligue1, title: "Ligue 1"))
        selections.append(LeagueSelection(key: .mls, title: "Major League Soccer"))
        selections.append(LeagueSelection(key: .premierLeague, title: "Premier League"))
        selections.append(LeagueSelection(key: .serieA, title: "Serie A"))
    }
}
