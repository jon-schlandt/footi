//
//  LeagueDataFilterDismissDelegate.swift
//  Footi
//
//  Created by Jon Schlandt on 6/21/23.
//

import UIKit

protocol LeagueDataFilterDismissDelegate: AnyObject {
    func resetDropdown()
}

class LeagueDataFilterNavigationController: BaseNavigationController {

    public weak var dismissDelegate: LeagueDataFilterDismissDelegate?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let _ = self.topViewController as? LeagueDataFilterViewController {
            dismissDelegate?.resetDropdown()
        }
    }
}
