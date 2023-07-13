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

/// Helper methods
extension HomeTabBarController {
    
    private func getStandingsTab() -> BaseNavigationController {
        let viewController = StandingsViewController()
        viewController.title = "Standings"
        viewController.tabBarItem = UITabBarItem(
            title: viewController.title,
            image: UIImage(systemName: "trophy")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18.0, weight: .light, scale: .medium)),
            selectedImage: UIImage(systemName: "trophy.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18.0, weight: .light, scale: .medium))
        )
        
        return BaseNavigationController(rootViewController: viewController)
    }
    
    private func getFixturesTab() -> BaseNavigationController {
        let viewController = FixturesViewController()
        viewController.title = "Fixtures"
        viewController.tabBarItem = UITabBarItem(
            title: viewController.title,
            image: UIImage(systemName: "sportscourt")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18.0, weight: .light, scale: .medium)),
            selectedImage: UIImage(systemName: "sportscourt.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18.0, weight: .light, scale: .medium))
        )
        
        return BaseNavigationController(rootViewController: viewController)
    }
    
    private func getLeadersTab() -> BaseNavigationController {
        let viewController = LeadersViewController()
        viewController.title = "Leaders"
        viewController.tabBarItem = UITabBarItem(
            title: viewController.title,
            image: UIImage(systemName: "medal")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18.0, weight: .light, scale: .medium)),
            selectedImage: UIImage(systemName: "medal.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18.0, weight: .light, scale: .medium))
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
