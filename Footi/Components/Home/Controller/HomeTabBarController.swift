//
//  HomeTabBarController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/11/23.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [
            getStandingsTab(),
            getFixturesTab(),
            getLeadersTab()
        ]
        
        styleView()
    }
}

/// Private methods
extension HomeTabBarController {
    
    private func getStandingsTab() -> BaseNavigationController {
        let viewController = StandingsViewController()
        viewController.title = "Standings"
        viewController.tabBarItem = UITabBarItem(
            title: viewController.title,
            image: UIImage(systemName: "trophy", withConfiguration: UIImage.SymbolConfiguration(weight: .light)),
            selectedImage: UIImage(systemName: "trophy.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))
        )
        
        return BaseNavigationController(rootViewController: viewController)
    }
    
    private func getFixturesTab() -> BaseNavigationController {
        let viewController = FixturesViewController()
        viewController.title = "Fixtures"
        viewController.tabBarItem = UITabBarItem(
            title: viewController.title,
            image: UIImage(systemName: "sportscourt", withConfiguration: UIImage.SymbolConfiguration(weight: .light)),
            selectedImage: UIImage(systemName: "sportscourt.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))
        )
        
        return BaseNavigationController(rootViewController: viewController)
    }
    
    private func getLeadersTab() -> BaseNavigationController {
        let viewController = LeadersViewController()
        viewController.title = "Leaders"
        viewController.tabBarItem = UITabBarItem(
            title: viewController.title,
            image: UIImage(systemName: "medal", withConfiguration: UIImage.SymbolConfiguration(weight: .light)),
            selectedImage: UIImage(systemName: "medal.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))
        )
        
        return BaseNavigationController(rootViewController: viewController)
    }
    
    private func styleView() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.Palette.bar
        
        self.tabBar.standardAppearance = appearance;
        self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
        self.tabBar.tintColor = UIColor.Palette.primaryIcon
        self.tabBar.unselectedItemTintColor = UIColor.Palette.primaryIcon
    }
}
