//
//  UIColor.swift
//  Footi
//
//  Created by Jon Schlandt on 3/30/23.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
    
    struct Palette {
        static let background = UIColor(named: "background")
        static let bar = UIColor(named: "bar")
        static let border = UIColor(named: "border")
        static let foreground = UIColor(named: "foreground")
        static let primaryIcon = UIColor(named: "primaryIcon")
        static let secondaryIcon = UIColor(named: "secondaryIcon")
        static let live = UIColor(named: "live")
        static let primaryText = UIColor(named: "primaryText")
        static let secondaryText = UIColor(named: "secondaryText")
    }
}
