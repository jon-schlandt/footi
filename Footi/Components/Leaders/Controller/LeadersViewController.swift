//
//  LeadersViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/12/23.
//

import UIKit

class LeadersViewController: BaseViewContoller {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Leaders"
    }
    
    override func loadModel() async {
        let selectedLeague = self.userDefaultsContext.getSelectedLeague()
        guard let selectedLeague = selectedLeague else {
            return
        }
        
        let displayName = selectedLeague["displayName"]
        if let displayName = displayName {
            print("loading leaders for \(displayName)")
        }
    }
}
