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

/// UIViewController methods
class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        setupLeagueSelect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Menu"
        
        setupNavigation()
        styleView()
    }
}

/// LeagueSelectViewControllerDelegate methods
extension MenuViewController: LeagueSelectViewControllerDelegate {
    
    internal func selectLeague() {
        delegate?.selectLeague()
    }
}

/// Private methods
extension MenuViewController {
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(displaySettings)
        )
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeMenu)
        )
    }
    
    private func setupLeagueSelect() {
        let leagueSelectVC = LeagueSelectViewController()
        leagueSelectVC.delegate = self
        self.addChild(leagueSelectVC)
        
        let leagueSelectStackView = LeagueSelectStackView(leagueSelect: leagueSelectVC.view)
        self.view.addSubview(leagueSelectStackView)
        
        NSLayoutConstraint.activate([
            leagueSelectStackView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            leagueSelectStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
    
    private func styleView() {
        self.view.backgroundColor = UIColor.Palette.background
    }
    
    @objc private func displaySettings() {
        delegate?.displaySettings()
    }
    
    @objc private func closeMenu() {
        delegate?.closeMenu()
    }
}
