//
//  UIView.swift
//  Footi
//
//  Created by Jon Schlandt on 3/21/23.
//

import Foundation
import UIKit

extension UIView {
    
    func addBorders(edges: UIRectEdge = .all, color: UIColor = .black, width: CGFloat = AppConstants.baseBorderWidth, offset: CGFloat = 0) {
        if (edges.contains(.all) || edges.contains(.top)) {
            let topBorder = createBorder(color: color)
            self.addSubview(topBorder)
            
            NSLayoutConstraint.activate([
                topBorder.topAnchor.constraint(equalTo: self.topAnchor),
                topBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset),
                topBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset),
                topBorder.heightAnchor.constraint(equalToConstant: width)
            ])
        }
        
        if (edges.contains(.all) || edges.contains(.left)) {
            let leftBorder = createBorder(color: color)
            self.addSubview(leftBorder)
            
            NSLayoutConstraint.activate([
                leftBorder.topAnchor.constraint(equalTo: self.topAnchor, constant: offset),
                leftBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -offset),
                leftBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                leftBorder.widthAnchor.constraint(equalToConstant: width)
            ])
        }
        
        if (edges.contains(.all) || edges.contains(.right)) {
            let rightBorder = createBorder(color: color)
            self.addSubview(rightBorder)
            
            NSLayoutConstraint.activate([
                rightBorder.topAnchor.constraint(equalTo: self.topAnchor, constant: offset),
                rightBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -offset),
                rightBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                rightBorder.widthAnchor.constraint(equalToConstant: width)
            ])
        }
        
        if (edges.contains(.all) || edges.contains(.bottom)) {
            let bottomBorder = createBorder(color: color)
            self.addSubview(bottomBorder)
            
            NSLayoutConstraint.activate([
                bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset),
                bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset),
                bottomBorder.heightAnchor.constraint(equalToConstant: width)
            ])
        }
    }
    
    private func createBorder(color: UIColor) -> UIView {
        let borderView = UIView(frame: CGRect.zero)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = color
        
        return borderView
    }
}
