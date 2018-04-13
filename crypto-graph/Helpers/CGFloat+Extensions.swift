//
//  CGFloat+Extensions.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 10.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import UIKit

extension CGFloat {

    /// Formats the CGFloat to a maximum of 1 decimal place.
    var formattedToOneDecimalPlace : String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: self.native)) ?? "\(self)"
    }
}
