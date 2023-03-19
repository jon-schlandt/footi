//
//  HomeTabBarController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/11/23.
//

import UIKit

/// Lifecycle methods
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
        viewController.tabBarItem = UITabBarItem(title: viewController.title,
                                                 image: UIImage(systemName: "trophy"),
                                                 selectedImage: UIImage(systemName: "trophy.fill"))
        
        return BaseNavigationController(rootViewController: viewController)
    }
    
    private func getFixturesTab() -> BaseNavigationController {
        let viewController = FixturesViewController()
        viewController.title = "Fixtures"
        viewController.tabBarItem = UITabBarItem(title: viewController.title,
                                                 image: UIImage(systemName: "sportscourt"),
                                                 selectedImage: UIImage(systemName: "sportscourt.fill"))
        
        return BaseNavigationController(rootViewController: viewController)
    }
    
    private func getLeadersTab() -> BaseNavigationController {
        let viewController = LeadersViewController()
        viewController.title = "Leaders"
        viewController.tabBarItem = UITabBarItem(title: viewController.title,
                                                 image: UIImage(systemName: "medal"),
                                                 selectedImage: UIImage(systemName: "medal.fill"))
        
        return BaseNavigationController(rootViewController: viewController)
    }
    
    private func styleView() {
        
        // Color
        tabBar.tintColor = .label
    }
}
