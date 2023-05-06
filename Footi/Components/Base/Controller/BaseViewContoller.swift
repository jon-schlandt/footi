//
//  BaseViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/18/23.
//

import UIKit

class BaseViewContoller: UIViewController {

    // MARK: Data stores
    
    let coreDataContext = CoreDataContext()
    let userDefaultsContext = UserDefaultsContext()
    
    // MARK: Networking
    
    let fixturesService = FixturesService()
    let leadersService = LeadersService()
    let leaguesService = LeaguesService()
    let standingsService = StandingsService()
    
    // MARK: Controllers
    
    var menuNav: BaseNavigationController!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupMenu()
        styleView()
    }
    
    internal func loadLeagueHeaderDetails() async {
        fatalError("loadLeagueHeaderDetails() has not been implemented")
    }
    
    internal func loadModel() async {
        fatalError("loadModel() has not been implemented")
    }
}

extension BaseViewContoller: MenuViewControllerDelegate {
    
    internal func selectLeague() {
        closeMenu()
        
        _Concurrency.Task {
            await loadLeagueHeaderDetails()
            await loadModel()
        }
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
extension BaseViewContoller {
    
    private func setupNavigation() {
        self.navigationItem.backButtonTitle = ""
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal", withConfiguration: UIImage.SymbolConfiguration(weight: .light)),
            style: .plain,
            target: self,
            action: #selector(displayMenu)
        )
    }
    
    @objc private func displayMenu() {
        if let sheet = menuNav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(menuNav, animated: true)
    }
    
    private func setupMenu() {
        let menuVC = MenuViewController()
        menuVC.delegate = self

        menuNav = BaseNavigationController(rootViewController: menuVC)
    }
    
    private func styleView() {
        self.view.backgroundColor = UIColor.Palette.background
    }
}
