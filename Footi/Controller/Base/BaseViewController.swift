//
//  BaseViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/18/23.
//

import UIKit

/// Lifecycle methods
class BaseViewController: UIViewController {

    // Data stores
    let coreDataContext = CoreDataContext()
    let userDefaultsContext = UserDefaultsContext()
    
    // Networking
    let fixturesService = FixturesService()
    let leadersService = LeadersService()
    let leaguesService = LeaguesService()
    let standingsService = StandingsService()
    
    // Shared VCs
    var menuNav: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupMenu()
        styleView()
    }
}

/// Delegate methods
extension BaseViewController: MenuViewControllerDelegate {
    
    internal func displaySettings() {
        closeMenu()
        
        let settingsVC = SettingsViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    internal func closeMenu() {
        menuNav.dismiss(animated: true)
    }
}

/// Private methods
extension BaseViewController {
    
    private func setupNavigation() {
        self.navigationItem.backButtonTitle = ""
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(displayMenu)
        )
        
        self.navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    private func setupMenu() {
        let menuVC = MenuViewController()
        menuVC.delegate = self

        menuNav = UINavigationController(rootViewController: menuVC)
        
        if let menuSheet = menuNav.sheetPresentationController {
            menuSheet.detents = [.medium(), .large()]
            menuSheet.selectedDetentIdentifier = .medium
            menuSheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
    }
    
    private func styleView() {
        view.backgroundColor = .systemBackground
    }
    
    @objc func displayMenu() {
        present(menuNav, animated: true)
    }
}
