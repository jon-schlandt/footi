//
//  BaseNavigationController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/18/23.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        self.navigationBar.backgroundColor = .yellow
        self.navigationBar.tintColor = .label
    }
}
