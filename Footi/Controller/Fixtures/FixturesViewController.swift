//
//  FixturesViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/12/23.
//

import UIKit

class FixturesViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Fixtures"
    }
    
    override func loadModel(for league: String) {
        let selectedLeague = self.userDefaultsContext.getSelectedLeague()
        guard let selectedLeague = selectedLeague else {
            return
        }
        
        let displayName = selectedLeague["displayName"]
        if let displayName = displayName {
            print("loading fixtures for \(displayName)")
        }
    }
}
