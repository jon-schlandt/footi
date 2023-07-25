//
//  BaseNavigationController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/18/23.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backIndicator = UIImage(systemName: "arrow.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18.0, weight: .light, scale: .medium))
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.setBackIndicatorImage(backIndicator, transitionMaskImage: backIndicator)
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = UIColor.Palette.bar
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: FontConstants.title, size: FontConstants.largeSize)!,
            NSAttributedString.Key.foregroundColor: UIColor.Palette.barText!
        ]

        self.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationBar.compactAppearance = navigationBarAppearance
        self.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        self.navigationBar.tintColor = UIColor.Palette.primarySymbol
    }
}
