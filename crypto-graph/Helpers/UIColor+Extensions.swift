//
//  UIColor+Extensions.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 08.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: Int) {
        self.init(hex:hex, alpha:1.0)
    }

    convenience init(hex: Int, alpha: CGFloat) {
        let red = CGFloat((0xff0000 & hex) >> 16) / 255.0
        let green = CGFloat((0xff00 & hex) >> 8) / 255.0
        let blue = CGFloat(0xff & hex) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
