//
//  StandingsViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/12/23.
//

import UIKit

class StandingsViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Standings"
    }
    
    override func loadModel() {
        let selectedLeague = self.userDefaultsContext.getSelectedLeague()
        guard let selectedLeague = selectedLeague else {
            return
        }
        
        let displayName = selectedLeague["displayName"]
        if let displayName = displayName {
            print("loading standings for \(displayName)")
        }
    }
}
