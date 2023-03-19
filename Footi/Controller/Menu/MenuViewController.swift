//
//  MenuViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/14/23.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func displaySettings()
    func closeMenu()
}

/// Lifecycle methods
class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Menu"
        self.view.backgroundColor = .systemBackground
    }
}

/// Private methods
extension MenuViewController {
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(displaySettings))
        self.navigationItem.leftBarButtonItem?.tintColor = .label
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeMenu))
        self.navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    @objc func displaySettings() {
        delegate?.displaySettings()
    }
    
    @objc func closeMenu() {
        delegate?.closeMenu()
    }
}
