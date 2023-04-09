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
    var menuNav: BaseNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupMenu()
        styleView()
    }
    
    internal func loadModel() {
        fatalError("loadModel() has not been implemented")
    }
}

/// MenuViewControllerDelegate methods
extension BaseViewController: MenuViewControllerDelegate {
    
    internal func selectLeague() {
        closeMenu()
        loadModel()
    }
    
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
    }
    
    private func setupMenu() {
        let menuVC = MenuViewController()
        menuVC.delegate = self

        menuNav = BaseNavigationController(rootViewController: menuVC)
    }
    
    private func styleView() {
        self.view.backgroundColor = UIColor(hex: "#f9f9f9ff")
    }
    
    @objc func displayMenu() {
        if let menuSheet = menuNav.sheetPresentationController {
            menuSheet.detents = [.large()]
            menuSheet.selectedDetentIdentifier = .large
            menuSheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(menuNav, animated: true)
    }
}
