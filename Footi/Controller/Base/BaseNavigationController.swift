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

        navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        navigationBar.tintColor = .label
    }
}
