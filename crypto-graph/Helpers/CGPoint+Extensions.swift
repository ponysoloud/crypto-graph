//
//  CGPoint+Extensions.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 09.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import UIKit

extension CGPoint {
    var inverted: CGPoint {
        return CGPoint(x: -x, y: -y)
    }
}
