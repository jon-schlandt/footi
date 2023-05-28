//
//  LeagueSelectViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/19/23.
//

import UIKit

protocol LeagueSelectViewControllerDelegate: AnyObject {
    func selectLeague()
}

class LeagueSelectViewController: UICollectionViewController {
    
    // MARK: Model
    
    var flowLayout: UICollectionViewFlowLayout!
    weak var delegate: LeagueSelectViewControllerDelegate?
    
    let userDefaultsContext = UserDefaultsContext()
    var selections = [LeagueSelection]()
    
    // MARK: Lifecycle
    
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

extension LeagueSelectViewController: LeagueSelectCellDelegate {
    
    internal func selectLeague(_ leagueKey: String) {
        userDefaultsContext.setSelectedLeague(as: leagueKey)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.delegate?.selectLeague()
        }
    }
}

/// Private methods
extension LeagueSelectViewController {
    
    private func setSelections() {
        let leagueMap = userDefaultsContext.getLeagues()
        guard let leagueMap = leagueMap else {
            return
        }
        
        let leagueKeys = leagueMap.keys.sorted { $0 < $1 }
        leagueKeys.forEach { key in
            let league = leagueMap[key]
            guard let league = league else {
                return
            }
            
            guard let id = league["id"] as? Int else {
                return
            }
            
            guard let title = league["displayName"] as? String else {
                return
            }
            
            selections.append(LeagueSelection(id: id, key: key, title: title))
        }
    }
}
