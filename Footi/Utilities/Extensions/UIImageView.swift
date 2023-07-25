//
//  UIImageView.swift
//  Footi
//
//  Created by Jon Schlandt on 3/26/23.
//

import Foundation
import UIKit

extension UIImageView {
    
    // MARK: Public methods
    
    public func loadFromCache(url: URL) {
        let request = URLRequest(url: url)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            self.image = UIImage(data: cachedResponse.data)
        } else {
            load(url: url)
        }
    }
    
    public func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
