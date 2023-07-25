//
//  UIView.swift
//  Footi
//
//  Created by Jon Schlandt on 3/21/23.
//

import Foundation
import UIKit

extension UIView {
    
    internal func addBorders(edges: UIRectEdge = .all, color: UIColor = .black, width: CGFloat = AppConstants.baseBorderWidth, lOffset: CGFloat = 0, rOffset: CGFloat = 0) -> [UIView] {
        var borders = [UIView]()
        
        if (edges.contains(.all) || edges.contains(.top)) {
            let topBorder = createBorder(color: color)
            self.addSubview(topBorder)
            
            NSLayoutConstraint.activate([
                topBorder.topAnchor.constraint(equalTo: self.topAnchor),
                topBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lOffset),
                topBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -rOffset),
                topBorder.heightAnchor.constraint(equalToConstant: width)
            ])
            
            borders.append(topBorder)
        }
        
        if (edges.contains(.all) || edges.contains(.left)) {
            let leftBorder = createBorder(color: color)
            self.addSubview(leftBorder)
            
            NSLayoutConstraint.activate([
                leftBorder.topAnchor.constraint(equalTo: self.topAnchor, constant: lOffset),
                leftBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -rOffset),
                leftBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                leftBorder.widthAnchor.constraint(equalToConstant: width)
            ])
            
            borders.append(leftBorder)
        }
        
        if (edges.contains(.all) || edges.contains(.right)) {
            let rightBorder = createBorder(color: color)
            self.addSubview(rightBorder)
            
            NSLayoutConstraint.activate([
                rightBorder.topAnchor.constraint(equalTo: self.topAnchor, constant: lOffset),
                rightBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -rOffset),
                rightBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                rightBorder.widthAnchor.constraint(equalToConstant: width)
            ])
            
            borders.append(rightBorder)
        }
        
        if (edges.contains(.all) || edges.contains(.bottom)) {
            let bottomBorder = createBorder(color: color)
            self.addSubview(bottomBorder)
            
            NSLayoutConstraint.activate([
                bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lOffset),
                bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -rOffset),
                bottomBorder.heightAnchor.constraint(equalToConstant: width)
            ])
            
            borders.append(bottomBorder)
        }
        
        return borders
    }
    
    // MARK: Private helpers
    
    private func createBorder(color: UIColor) -> UIView {
        let borderView = UIView(frame: CGRect.zero)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = color
        
        return borderView
    }
}
