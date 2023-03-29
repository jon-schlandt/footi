//
//  MenuViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/14/23.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func selectLeague(_ league: String)
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
    
    internal func selectLeague(_ league: String) {
        delegate?.selectLeague(league)
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
        
        self.navigationItem.leftBarButtonItem?.tintColor = .label
        self.navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    private func setupLeagueSelect() {
        let leagueSelectVC = LeagueSelectViewController()
        leagueSelectVC.delegate = self
        self.addChild(leagueSelectVC)
        
        let leagueSelectStackView = LeagueSelectStackView(leagueSelectView: leagueSelectVC.view)
        self.view.addSubview(leagueSelectStackView)
        
        NSLayoutConstraint.activate([
            leagueSelectStackView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            leagueSelectStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            leagueSelectStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            leagueSelectStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        ])
    }
    
    private func styleView() {
        self.view.backgroundColor = .systemBackground
    }
    
    @objc private func displaySettings() {
        delegate?.displaySettings()
    }
    
    @objc private func closeMenu() {
        delegate?.closeMenu()
    }
}
