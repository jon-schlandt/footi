//
//  MenuViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/14/23.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func selectLeague()
    func displaySettings()
    func closeMenu()
}

class MenuViewController: UIViewController {
    
    // MARK: Subviews
    
    public var leagueSelectVC: LeagueSelectViewController!
    
    // MARK: Model
    
    public weak var delegate: MenuViewControllerDelegate?
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let rootView = UIView()
        leagueSelectVC = LeagueSelectViewController()
        
        self.addChild(leagueSelectVC)
        rootView.addSubview(leagueSelectVC.view)
        
        NSLayoutConstraint.activate([
            leagueSelectVC.view.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            leagueSelectVC.view.heightAnchor.constraint(equalTo: rootView.widthAnchor, multiplier: (2 / 3), constant: AppConstants.baseCellHeight),
            leagueSelectVC.view.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor)
        ])
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Menu"
        leagueSelectVC.delegate = self
        
        setupNavigation()
        styleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        leagueSelectVC.setSelections()
        leagueSelectVC.collectionView.reloadData()
    }
}

// MARK: Delegates

extension MenuViewController: LeagueSelectViewControllerDelegate {
    
    internal func selectLeague() {
        leagueSelectVC.setSelections()
        leagueSelectVC.collectionView.reloadData()
        
        delegate?.selectLeague()
    }
}

// MARK: Private helpers

extension MenuViewController {
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18.0, weight: .light, scale: .medium)),
            style: .plain,
            target: self,
            action: #selector(displaySettings)
        )
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18.0, weight: .light, scale: .medium)),
            style: .plain,
            target: self,
            action: #selector(closeMenu)
        )
    }
    
    private func styleView() {
        self.view.backgroundColor = UIColor.Palette.primaryBackground
    }
    
    @objc private func displaySettings() {
        delegate?.displaySettings()
    }
    
    @objc private func closeMenu() {
        delegate?.closeMenu()
    }
}
